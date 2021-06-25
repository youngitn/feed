import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget PackingLineRoad(String text) {
  return Expanded(
    child: Container(
      alignment: Alignment.center,
      width: Get.context!.isLandscape ? 50 : 1,
      height: Get.context!.isLandscape ? 50 : 80,
      // decoration: BoxDecoration(
      //   color: Colors.grey,
      // ),
      child: Text(
        text,
        style: TextStyle(fontSize: 1.0),
      ),
    ),
  );
}
