import 'package:feed/app/data/materiel.dart';
import 'package:feed/app/modules/home_module/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:feed/app/theme/app_colors.dart';

import 'feed_item_info_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FeedItemInfo extends GetWidget {
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return Obx(() {
      Materiel materiel =
      homeController.materiels.elementAt(homeController.index.value);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('物料資訊'),
                  //color: Colors.green,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 30),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('物料編號:'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('${materiel.sku}'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('物料名稱:'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('${materiel.name}'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('儲位:'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('${materiel.locationCode}'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('數量:'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('${materiel.qty}'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text('單位:'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('${materiel.unit}'),
                  color: Colors.white10,
                  width: context.widthTransformer(dividedBy: 2),
                  height: context.heightTransformer(dividedBy: 7),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
