// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'package:workmanager/workmanager.dart';

import 'app/modules/packing_line/home_module/home_page.dart';
import 'app/routes/app_pages.dart';
import 'app/service/mqtt/mqtt_service.dart';
import 'app/theme/app_theme.dart';

//init要用到的服務
Future<void> initServices() async {
  print('starting services ...');

  /// Here is where you put get_storage, hive, shared_pref initialization.
  /// or moor connection, or whatever that's async.

  MqttService mqttService = Get.put(MqttService());
  mqttService.init();
  print('All services started...');
}

Future<void> main() async {
  await initServices();
  //資料持久化套件
  await GetStorage.init();
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  //背景執行程序初始化
  Workmanager().initialize(

      // The top level function, aka callbackDispatcher
      //用來mapping執行邏輯的switch
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      //true會輸出額為資訊
      isInDebugMode: false);
// Periodic task registration
  ///註冊一個週期訊息 最快只能每15分鐘執行一次
//   Workmanager().registerPeriodicTask(
//     "2",
//
//     //This is the value that will be
//     // returned in the callbackDispatcher
//     "simplePeriodicTask",
//
//     // When no frequency is provided
//     // the default 15 minutes is set.
//     // Minimum frequency is 15 min.
//     // Android will automatically change
//     // your frequency to 15 min
//     // if you have configured a lower frequency.
//     frequency: Duration(minutes: 1),
//   );
  runApp(MyApp());
}

//Workmanager的邏輯分配器 根據task mapping執行邏輯
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print(task);
    switch (task) {
      case 'test':
        print("test was executed");
        // initialise the plugin of flutterlocalnotifications.
        FlutterLocalNotificationsPlugin flip =
            new FlutterLocalNotificationsPlugin();

        // app_icon needs to be a added as a drawable
        // resource to the Android head project.
        var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
        var IOS = new IOSInitializationSettings();

        // initialise settings for both Android and iOS device.
        var settings = new InitializationSettings(android: android, iOS: IOS);
        flip.initialize(settings);

        _showNotificationWithDefaultSound(flip, inputData);
        break;
    }

    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip, inputData) async {
// Show a notification after every 15 minute with the first
// appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '7788', '測試名稱', '描述',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

// initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(
      0, '您收到一筆異常通知', '${inputData['payload']}', platformChannelSpecifics,
      payload: '${inputData['payload']}');
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    ///HomeController為首頁,使用會binding來不及綁
    //Get.put<HomeController>(HomeController());
    return GetMaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: AppPages.pages,
      home: HomePage(),
      title: '包裝線待補料狀態',
      theme: appThemeData,
    );
  }
}
