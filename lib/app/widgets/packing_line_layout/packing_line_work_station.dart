import 'package:feed/app/data/model/work_station_info.dart';
import 'package:feed/app/modules/packing_line/home_module/home_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget PackingLineWorkStation(WorkStationInfo ws) {
  HomeController homeController = Get.find();
  return Expanded(
      child: Row(
    //crossAxisAlignment: ws.id!.startsWith('A') || ws.id!.startsWith('C')?CrossAxisAlignment.start:CrossAxisAlignment.end,
    mainAxisAlignment: ws.id!.startsWith('B') || ws.id!.startsWith('D')
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,

    children: [
      (ws.id!.startsWith('B') || ws.id!.startsWith('D')) && ws.type != null
          ? Container(
              alignment: Alignment.center,
              width: Get.context!.isLandscape ? 30 : 25,
              height: Get.context!.isLandscape ? 50 : 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                color: Colors.greenAccent,
              ),
              child: Column(
                children: [
                  Text(
                    '${ws.type ?? ''}',
                    style: TextStyle(
                        fontSize: Get.context!.isLandscape ? 15 : 14,
                        color: Colors.black),
                  )
                ],
              ),
            )

          ///A&C line note box
          : ws.id!.startsWith('C') || ws.id!.startsWith('A')
              ? Container(
                  alignment: Alignment.center,
                  width: Get.context!.isLandscape ? 30 : 25,
                  height: Get.context!.isLandscape ? 50 : 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${ws.note ?? ''}',
                        style: TextStyle(
                            fontSize: Get.context!.isLandscape ? 15 : 14,
                            color: Colors.black),
                      )
                    ],
                  ),
                )
              : Container(),
      Container(
        alignment: Alignment.center,
        width: Get.context!.isLandscape ? 150 : 80,
        height: Get.context!.isLandscape ? 50 : 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown),
          color: Colors.yellow[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ws.id.toString(),
              style: TextStyle(
                  fontSize: Get.context!.isLandscape ? 15 : 15,
                  color: Colors.black),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: Get.context!.isLandscape ? 25 : 30,
                //   width: 30,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.blueAccent),
                //     color: ws.status!.yellowBoxColor,
                //   ),
                // ),
                // Container(
                //   height: Get.context!.isLandscape ? 25 : 30,
                //   width: 30,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.blueAccent),
                //     color: ws.status!.blueBoxColor,
                //   ),
                // ),
                homeController.getYellowBoxColor(
                    ws.status!.yellowBox, ws.status!.yellowBoxColor),
                SizedBox(
                  height: 30,
                  width: 10,
                ),
                homeController.getBlueBoxColor(
                    ws.status!.blueBox, ws.status!.blueBoxColor),
              ],
            ),
          ],
        ),
      ),
      (ws.id!.startsWith('C') || ws.id!.startsWith('A')) && ws.type != null
          ? Container(
              alignment: Alignment.center,
              width: Get.context!.isLandscape ? 30 : 25,
              height: Get.context!.isLandscape ? 50 : 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                color: Colors.greenAccent,
              ),
              child: Column(
                children: [
                  Text(
                    '${ws.type ?? ''}',
                    style: TextStyle(
                        fontSize: Get.context!.isLandscape ? 15 : 15,
                        color: Colors.black),
                  )
                ],
              ),
            )
          : ws.id!.startsWith('B') || ws.id!.startsWith('D')
              ? Container(
                  alignment: Alignment.center,
                  width: Get.context!.isLandscape ? 30 : 25,
                  height: Get.context!.isLandscape ? 50 : 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${ws.note ?? ''}',
                        style: TextStyle(
                            fontSize: Get.context!.isLandscape ? 15 : 14,
                            color: Colors.black),
                      )
                    ],
                  ),
                )
              : Container(),
    ],
  ));
}
