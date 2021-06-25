import 'package:feed/app/modules/login_modules/login_page.dart';
import 'package:feed/app/modules/packing_line/home_module/home_bindings.dart';
import 'package:feed/app/modules/packing_line/home_module/home_page.dart';
import 'package:feed/app/modules/shopping_car_modules/shopping_car_page.dart';


import 'package:get/get.dart';

part './app_routes.dart';
/**
 * GetX Generator - fb.com/htngu.99
 * */

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      //binding: FeedItemInfoBinding(),
    ),
    GetPage(
      name: Routes.SHOPPING_CAR,
      page: () => ShoppingCarPage(),

    ),
  ];
}
