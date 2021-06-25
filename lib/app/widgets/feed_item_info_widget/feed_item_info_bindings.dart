
import 'package:get/get.dart';

import 'feed_item_info_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FeedItemInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedItemInfoController());
  }
}