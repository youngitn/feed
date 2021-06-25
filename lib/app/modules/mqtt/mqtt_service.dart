import 'dart:io';


import 'package:feed/app/data/model/work_station_info.dart';
import 'package:feed/app/data/repository/work_station_repo.dart';
import 'package:feed/app/modules/packing_line/home_module/home_controller.dart';

import 'package:get/get.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

class MqttService extends GetxService {
  /// Edit as needed.

  HomeController homeController = Get.put(HomeController());
  WprkStationRepo repo = WprkStationRepo();
  String hostName = 'broker.emqx.io';
  MqttServerClient? client;
  String pubTopic = 'test/lolx';
  bool topicNotified = false;
  MqttPayloadBuilder? builder;

  Future<MqttService> init() async {

    print('MqttController go');
    client = MqttServerClient(hostName, '');

    builder = MqttPayloadBuilder();

    client!.logging(on: false);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client!.keepAlivePeriod = 60;

    /// Add the unsolicited disconnection callback
    client!.onDisconnected = onDisconnected;

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
        .withClientIdentifier('mqttx_a656fa9b')
        .startClean()
        .withUserProperties([property]);
    print('EXAMPLE::Mqtt5 client connecting....');
    client!.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// its possible that in some circumstances the broker will just disconnect us, see the spec about this,
    /// we however will never send malformed messages.
    try {
      await client!.connect();
    } on MqttNoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client!.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client!.disconnect();
    }

    /// Check we are connected. connectionStatus always gives us this and other information.
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      print(
          'EXAMPLE::Mqtt5 server client connected, return code is ${client!.connectionStatus!.reasonCode.toString().split('.')[1]}');

      /// All returned properties in the connect acknowledge message are available.
      /// Get our user properties from the connect acknowledge message.
      if (client!
          .connectionStatus!.connectAckMessage.userProperty!.isNotEmpty) {
        print(
            'EXAMPLE::Connected - user property name - ${client!.connectionStatus!.connectAckMessage.userProperty![0].pairName}');
        print(
            'EXAMPLE::Connected - user property value - ${client!.connectionStatus!.connectAckMessage.userProperty![0].pairValue}');
      }
    } else {
      print(
          'EXAMPLE::ERROR Mqtt5 client connection failed - status is ${client!.connectionStatus}');
      client!.disconnect();
      //exit(-1);
    }

    /// Ok, lets try a subscription
    print('EXAMPLE::Subscribing to the test/lolx topic');
    const topic = 'test/lolx'; // Not a wildcard topic
    client!.subscribe(topic, MqttQos.atMostOnce);
    client!.subscribeWithSubscription(MqttSubscription(MqttSubscriptionTopic('text/mqtt')));
    final builder1 = MqttPayloadBuilder();
    builder1.addString(
        'Hello from fromflutter fromflutter fromflutter fromflutter fromflutter');
    print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
    //推送給訂閱 test/fromflutter topic的訂閱者
    client!.publishMessage(
        'test/fromflutter', MqttQos.exactlyOnce, builder1.payload!);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client!.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt = MqttUtilities.bytesToStringAsString(recMess.payload.message!);
      print('123');
      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      homeController.notify(pt);
      final builder2 = MqttPayloadBuilder();
      builder2.addString('Hello from fromflutter! here get tour msg');

      repo.json = """
      [ 
      {"id":"A01","status":{"yellowBox":"0","blueBox":"1"}},
      {"id":"A02","status":{"yellowBox":"3","blueBox":"1"}},
      {"id":"A22","status":{"yellowBox":"0","blueBox":"1"}},
      {"id":"A04","status":{"yellowBox":"3","blueBox":"1"}},
      {"id":"A05","status":{"yellowBox":"0","blueBox":"1"}},
      {"id":"A06","status":{"yellowBox":"1","blueBox":"1"}},
      {"id":"A07","status":{"yellowBox":"2","blueBox":"1"}},
      {"id":"A08","status":{"yellowBox":"1","blueBox":"1"}},
      {"id":"A09","status":{"yellowBox":"2","blueBox":"1"}},
      {"id":"A10","status":{"yellowBox":"1","blueBox":"1"}},
      {"id":"A11","status":{"yellowBox":"3","blueBox":"1"}},
      {"id":"A12","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B01","status":{"yellowBox":"3","blueBox":"0"}},
      {"id":"B02","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B03","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"B04","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B05","status":{"yellowBox":"1","blueBox":"1"}},
      {"id":"B06","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B07","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"B08","status":{"yellowBox":"1","blueBox":"0"}},  
      {"id":"C01","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C45","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C03","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C04","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C05","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"C06","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"C07","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"C08","status":{"yellowBox":"1","blueBox":"0"}},
     {"id":"D01","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D18","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D03","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D04","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D05","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"D06","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D07","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"D08","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D09","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D10","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"D11","status":{"yellowBox":"3","blueBox":"1"}},
      {"id":"D12","status":{"yellowBox":"2","blueBox":"0"}}
      
      
      ]
      """;
      List<WorkStationInfo>? list =  await repo.getAll();
      homeController.buildLayout(list);


      print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
      //推送給訂閱 test/fromflutter topic的訂閱者
      client!.publishMessage(
          'test/fromflutter', MqttQos.atLeastOnce, builder2.payload!);

      /// Indicate the notification is correct
      if (c[0].topic == pubTopic) {
        topicNotified = true;
      }
    });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    client!.published!.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    /// Subscribe to our topic, we will publish to it in the onSubscribed callback.
    print('EXAMPLE::Subscribing to the Dart/Mqtt5_client/testtopic topic');
    client!.subscribe(pubTopic, MqttQos.exactlyOnce);

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
    print('EXAMPLE::訂閱的 topic=> ${subscription.topic.rawTopic}');

    /// 當訂閱指定tipic成功 則推送給尋錫給訂閱pubTopic的訂閱者
    if (subscription.topic.rawTopic == pubTopic) {
      /// Use the payload builder rather than a raw buffer
      builder!.addString('Hello from flutter subscribed callback');

      print('EXAMPLE::訂閱成功了喔 推送訊息給test/fromflutter的訂閱者');
      client!.publishMessage(
          'test/fromflutter', MqttQos.exactlyOnce, builder!.payload!);
    }
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client!.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      if (topicNotified) {
        print(
            'EXAMPLE::OnDisconnected callback is solicited, topic has been notified - this is correct');

        ///斷線後繼續訂閱

      } else {
        print(
            'EXAMPLE::OnDisconnected callback is solicited, topic has NOT been notified - this is an ERROR');
      }
    }

    ///斷線後繼續訂閱
    this.init();
    //exit(0);
  }

  /// The successful connect callback
  void onConnected() {
    print('EXAMPLE::連接成功');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }
}
