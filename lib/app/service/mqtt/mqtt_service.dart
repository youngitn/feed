import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:feed/app/data/model/work_station_info.dart';
import 'package:feed/app/data/repository/work_station_repo.dart';
import 'package:feed/app/modules/packing_line/home_module/home_controller.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:let_log/let_log.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:object_mapper/object_mapper.dart';

class MqttService extends GetxService {
  /// Edit as needed.

  HomeController homeController = Get.put(HomeController());
  WorkStationRepo repo = WorkStationRepo();
  String hostName = '10.60.1.210';
  MqttServerClient? client;

  //String pubTopic = 'test/lolx';
  String subTopic = 'pad/ws_all';
  String subTopicForOneMsg = 'pad/ws_bluebox';
  String subTopicForWS = 'pad/ws_single';
  bool topicNotified = false;
  MqttPayloadBuilder? builder;

  Future<MqttService> init() async {
    await GetStorage.init();
    final cid = 'ytc-padx${generateRandomString(5)}';
    print('MqttController go');
    client = MqttServerClient(hostName, cid);

    builder = MqttPayloadBuilder();

    client!.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client!.keepAlivePeriod = 60;
    client!.autoReconnect = true;

    /// Add the unsolicited disconnection callback
    client!.onDisconnected = onDisconnected;
    client!.onAutoReconnect = onAutoReconnect;
    client!.onAutoReconnected = onAutoReconnected;

    /// Add the successful connection callback
    client!.onConnected = onConnected;

    /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
    /// You can add these before connection or change them dynamically after connection if
    /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
    /// can fail either because you have tried to subscribe to an invalid topic or the broker
    /// rejects the subscribe request.
    client!.onSubscribed = onSubscribed;

    /// Set a ping received callback if needed, called whenever a ping response(pong) is received
    /// from the broker.
    client!.pongCallback = pong;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    /// Add some user properties, these may be available in the connect acknowledgement.
    /// Note there are many otions selectable on this message, if you opt to use authentication please see
    /// the example in mqtt5_server_client_authenticate.dart.
    final property = MqttUserProperty();
    property.pairName = '範例名';
    property.pairValue = '範例值';
    final connMess = MqttConnectMessage()
        .withClientIdentifier(cid)
        .startClean()
        .withUserProperties([property]);
    Logger.log('Mqtt5 client connecting....');
    client!.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// its possible that in some circumstances the broker will just disconnect us, see the spec about this,
    /// we however will never send malformed messages.
    try {
      await client!.connect('pad', 'pad');
    } on MqttNoConnectionException catch (e) {
      // Raised by the client when connection fails.
      Logger.error('::client exception - $e');
      client!.disconnect();
      homeController.aliveOrDead.value = 'dead';
    } on SocketException catch (e) {
      // Raised by the socket layer
      Logger.error('::socket exception - $e');
      client!.disconnect();
      homeController.aliveOrDead.value = 'dead';
    }

    /// Check we are connected. connectionStatus always gives us this and other information.
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      Logger.log(
          'Mqtt5 server client connected, return code is ${client!.connectionStatus!.reasonCode.toString().split('.')[1]}');

      /// All returned properties in the connect acknowledge message are available.
      /// Get our user properties from the connect acknowledge message.
      if (client!
          .connectionStatus!.connectAckMessage.userProperty!.isNotEmpty) {
        Logger.log(
            '已連線 - user property name - ${client!.connectionStatus!.connectAckMessage.userProperty![0].pairName}');
        Logger.log(
            '已連線 - user property value - ${client!.connectionStatus!.connectAckMessage.userProperty![0].pairValue}');
      }
      homeController.aliveOrDead.value = 'alive';
    } else {
      Logger.error(
          'ERROR Mqtt5 client connection failed - status is ${client!.connectionStatus}');
      client!.disconnect();
      homeController.aliveOrDead.value = 'dead';
      //exit(-1);
    }

    /// Ok, lets try a subscription


    client!.subscribe(subTopic, MqttQos.atLeastOnce);
    client!.subscribe(subTopicForOneMsg, MqttQos.atLeastOnce);
    client!.subscribe(subTopicForWS, MqttQos.atLeastOnce);

    // client!.subscribeWithSubscription(
    //     MqttSubscription(MqttSubscriptionTopic('text/mqtt')));
    // final builder1 = MqttPayloadBuilder();
    // builder1.addString(
    //     'Hello from fromflutter fromflutter fromflutter fromflutter fromflutter');
    // print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
    //推送給訂閱 test/fromflutter topic的訂閱者
    // client!.publishMessage(
    //     'test/fromflutter', MqttQos.exactlyOnce, builder1.payload!);

    final box = GetStorage();
    //List<WorkStationInfo>? lastList =  box.read('lastList');

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client!.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      Logger.log('收到的主題 ${c[0].topic}');
      if (c[0].topic == subTopic) {
        final recMess = c[0].payload as MqttPublishMessage;
        final pt = recMess.payload.message!;

        /// The above may seem a little convoluted for users only interested in the
        /// payload, some users however may be interested in the received publish message,
        /// lets not constrain ourselves yet until the package has been in the wild
        /// for a while.
        /// The payload is a byte buffer, this will be specific to the topic
        // print(
        //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');

        // Logger.log(pt);
        ///homeController.notify(pt);
        homeController.aliveOrDead.value = 'working';
        final builder2 = MqttPayloadBuilder();
        builder2.addString('Hello from fromflutter! here get tour msg');

        repo.json = utf8.decode(pt);
        List<WorkStationInfo>? list;

        try {
          list = await repo.getAll();

          homeController.aliveOrDead.value = 'working';
        } catch (e) {
          Logger.error('----------->' + e.toString());
          list = [];
        }
        box.write('lastList', list);
        homeController.buildLayout(list);

        // print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
        //推送給訂閱 test/fromflutter topic的訂閱者
        // client!.publishMessage(
        //     'test/fromflutter', MqttQos.atLeastOnce, builder2.payload!);

        /// Indicate the notification is correct
        // if (c[0].topic == pubTopic) {
        //   topicNotified = true;
        // }
      }

      //只置換bliebox
      if (c[0].topic == subTopicForOneMsg) {
        final recMess = c[0].payload as MqttPublishMessage;
        final pt = recMess.payload.message!;
        dynamic ptJson = jsonDecode(utf8.decode(pt));
        WorkStationInfo? ws =
            Mapper.fromJson(ptJson).toObject<WorkStationInfo>();
        final box = GetStorage();
        Map<String, dynamic> map = Map<String, dynamic>();
        if (box.read('blueBoxMap') != null) {
          map = box.read('blueBoxMap');
        }

        print('ptJson' + map.keys.toString());
        // homeController.lastList!.forEach((lastE) {
        List<WorkStationInfo> tempList = box.read('lastList');
        int index = tempList.indexWhere((element) => element.id == ws!.id);

        WorkStationInfo? targetWs = tempList[index];
        String? ybox = targetWs.status!.yellowBox;
        ws!.status!.yellowBox = ybox;
        ws.note = targetWs.note;
        ws.type = targetWs.type;
        ws.status!.blueBox = '1';
        if (index >= 0) {
          tempList[index] = ws;
        }
        // }
        // );.
        box.write('lastList', tempList);
        map[ws.id.toString()] = '1';
        box.write('blueBoxMap', map);

        await homeController.buildLayout(tempList);
      }

      if (c[0].topic == subTopicForWS) {
        List<WorkStationInfo> tempList = box.read('lastList');
        final recMess = c[0].payload as MqttPublishMessage;
        final pt = recMess.payload.message!;
        dynamic ptJson = jsonDecode(utf8.decode(pt));
        WorkStationInfo? ws =
            Mapper.fromJson(ptJson).toObject<WorkStationInfo>();

        // homeController.lastList!.forEach((lastE) {
        int index = tempList.indexWhere((element) => element.id == ws!.id);

        if (index >= 0) {
          tempList[index] = ws!;
        }

        box.write('lastList', tempList);

        await homeController.buildLayout(tempList);
        //await homeController.buildLayoutx();
      }
    });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    // client!.published!.listen((MqttPublishMessage message) {
    //   print(
    //       'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    // });

    /// Subscribe to our topic, we will publish to it in the onSubscribed callback.
    // print('EXAMPLE::Subscribing to the Dart/Mqtt5_client/testtopic topic');
    // client!.subscribe(pubTopic, MqttQos.exactlyOnce);

    /// Ok, we will now sleep a while, in this gap you will see ping request/response
    /// messages being exchanged by the keep alive mechanism.
    // print('EXAMPLE::Sleeping....');
    // await MqttUtilities.asyncSleep(120);

    /// Finally, unsubscribe and exit gracefully
    ///print('EXAMPLE::退訂');

    ///client!.unsubscribeStringTopic(topic);

    /// Wait for the unsubscribe acknowledge message from the broker.
    /// We could also add an unsubscribe callback and do the disconnect in it.
    await MqttUtilities.asyncSleep(2);
    //print('EXAMPLE::Disconnecting');
    ///client!.disconnect();
    return this;
  }

  /// The subscribed callback
  void onSubscribed(MqttSubscription subscription) {
    Logger.log('EXAMPLE::訂閱的 topic=> ${subscription.topic.rawTopic}');

    /// 當訂閱指定tipic成功 則推送給尋錫給訂閱pubTopic的訂閱者
    // if (subscription.topic.rawTopic == pubTopic) {
    //   /// Use the payload builder rather than a raw buffer
    //   builder!.addString('Hello from flutter subscribed callback');
    //
    //   print('EXAMPLE::訂閱成功了喔 推送訊息給test/fromflutter的訂閱者');
    //   client!.publishMessage(
    //       'test/fromflutter', MqttQos.exactlyOnce, builder!.payload!);
    // }
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    homeController.aliveOrDead.value = 'dead';
    if (client!.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      if (topicNotified) {
        Logger.log(
            'EXAMPLE::OnDisconnected callback is solicited, topic has been notified - this is correct');

        ///斷線後繼續訂閱

      } else {
        Logger.error(
            'OnDisconnected callback is solicited, topic has NOT been notified - this is an ERROR');
        homeController.aliveOrDead.value = 'dead';
      }
    }

    ///斷線後繼續訂閱
    //this.init();
    //exit(0);
  }

  /// The successful connect callback
  void onConnected() {
    Logger.log('EXAMPLE::連接成功');
    homeController.aliveOrDead.value = 'alive';
  }

  /// Pong callback
  void pong() {
    Logger.log('***********ping mqtt broker**********');
  }

  void closeAppDisconnected() async {
    await MqttUtilities.asyncSleep(2);
    client?.disconnect();
  }

  void onAutoReconnect() {
    homeController.aliveOrDead.value = 'dead';
    Logger.log('MQTT Auto Reconnect...');
    homeController.aliveOrDead.value = 'dead';
  }

  void onAutoReconnected() {
    homeController.aliveOrDead.value = 'alive';
    Logger.log('MQTT Auto Reconnect success!');
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
