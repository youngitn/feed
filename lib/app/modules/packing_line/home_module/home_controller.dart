import 'dart:async';


import 'package:feed/app/data/repository/work_station_repo.dart';

import 'package:feed/app/widgets/packing_line_layout/color_animate_container.dart';
import 'package:feed/app/widgets/packing_line_layout/packing_line_road.dart';
import 'package:feed/app/widgets/packing_line_layout/packing_line_work_station.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feed/app/data/model/work_station_info.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';



/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeController extends GetxController {
  RxList<Widget> c1 = <Widget>[].obs;
  RxList<Widget> w1 = <Widget>[].obs;
  RxList<Widget> c2 = <Widget>[].obs;
  RxList<Widget> w2 = <Widget>[].obs;
  RxList<Widget> c3 = <Widget>[].obs;
  RxList<Widget> c4 = <Widget>[].obs;

  RxString aliveOrDead = ''.obs;

  var period = const Duration(seconds: 10);
  Timer? timer;


  Color isMqttStillAlive(){
    Color color = Colors.grey;
    switch(aliveOrDead.value){
      case 'alive':
        color = (Colors.green);
        break;
      case 'dead':
        color = (Colors.red);
        break;
    }
    return color;
  }

  Future<void> buildLayout(List<WorkStationInfo> list) async {
    List<Widget> al = [];
    List<Widget> bl = [];
    List<Widget> cl = [];
    List<Widget> dl = [];
    list.forEach((e) {
      String type = e.id!.substring(0, 1);

      switch (type) {
        case 'A':
          al.add(PackingLineWorkStation(e));
          break;
        case 'B':
          bl.add(PackingLineWorkStation(e));
          break;
        case 'C':
          cl.add(PackingLineWorkStation(e));
          break;
        case 'D':
          dl.add(PackingLineWorkStation(e));
          break;
      }
    });
    bl.insert(3, PackingLineRoad(''));
    cl.insert(3, PackingLineRoad(''));
    bl.insert(8, PackingLineRoad(''));
    cl.insert(8, PackingLineRoad(''));
    bl.insert(10, PackingLineRoad(''));
    cl.insert(10, PackingLineRoad(''));
    bl.insert(11, PackingLineRoad(''));
    cl.insert(11, PackingLineRoad(''));

    c1.assignAll(al);
    w1.assignAll(buildWorkStation(12, 'ROAD'));
    c2.assignAll(bl);
    c3.assignAll(cl);
    w2.assignAll(buildWorkStation(12, 'ROAD'));
    c4.assignAll(dl);
  }

  List<Widget> buildWorkStation(int count, String lineCode) {
    List<Widget> l = [];
    for (int i = 1; i <= 12; i++) {
      switch (lineCode) {
        case 'ROAD':
          l.add(PackingLineRoad(''));
          break;
      }
    }

    //l.add(PackingLineWorkStation('${lineCode}'));
    return l;
  }

  startUpdateWorkStationStatusCycleOperation() {
    timer = Timer.periodic(period, (timer) async {
      // TODO
      List<WorkStationInfo> list =
          await WprkStationRepo().getAll() as List<WorkStationInfo>;
      buildLayout(list);
    });
  }

  stopUpdateWorkStationStatusCycleOperation() {
    timer!.cancel();
  }

  Color getColorByStatus(Status status, String type) {
    switch (type) {
      case 'type1':
        switch (status.yellowBox) {
          case 'A':
            return Colors.red;
          case 'B':
            return Colors.green;
          case 'C':
            return Colors.orange;
          default:
            return Colors.black26;
        }
      case 'type2':
        switch (status.blueBox) {
          case 'A':
            return Colors.red;
          case 'B':
            return Colors.green;
          case 'C':
            return Colors.orange;
          default:
            return Colors.black26;
        }
      default:
        return Colors.black26;
    }
  }

  void notify(String payload) {
    print('HomeController.notify');
    Map<String, String> m = Map<String, String>();
    m['payload'] = payload;
    Workmanager().registerOneOffTask(
      "uniqueName",
      'test',
      //initialDelay: Duration(seconds: 10),
      inputData: m,
    );

  }

  @override
  void onInit() async {
    super.onInit();
    List<WorkStationInfo> list =
        await WprkStationRepo().getAll() as List<WorkStationInfo>;
    buildLayout(list);
    //startUpdateWorkStationStatusCycleOperation();
  }

  Widget getBlueBoxColor(String? blueBox, Color? blueBoxColor) {
    switch (blueBox) {
      case '0':
        return Container(
          height: Get.context!.isLandscape ? 25 : 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            color: blueBoxColor,
          ),
        );
      case '1':
        return ColorAnimateContainer(blueBoxColor);
    }
    return Text('?');
  }

  Widget getYellowBoxColor(String? yellowBox, Color? yellowBoxColor) {
    switch (yellowBox) {
      case '0':
      case '1':
      case '2':
        return Container(
          height: Get.context!.isLandscape ? 25 : 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            color: yellowBoxColor,
          ),
        );
      case '3':
        return ColorAnimateContainer(yellowBoxColor!);
    }
    return Text('?');
  }
}
