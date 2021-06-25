import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:object_mapper/object_mapper.dart';

/// id : ""
/// status : {"a":"","b":""}

class WorkStationInfo with Mappable {
  String? id;
  String? type;
  String? note;
  Status? status;

  WorkStationInfo({String? id, Status? status, String? type, String? note}) {
    id = id;
    type = type;
    note = note;
    status = status;
  }

  WorkStationInfo.fromJson(dynamic json) {
    id = json["id"];
    status = json["status"];
    note = json["note"];
    type = json["type"];
  }

  @override
  String toString() {
    return 'WorkStationInfo{id: $id, status: $status}';
  }

  @override
  void mapping(Mapper map) {
    map("id", id, (v) => id = v);
    map("type", type, (v) => type = v);
    map("note", note, (v) => note = v);
    map<Status>("status", status, (v) => status = v);
  }
}

/// a : ""
/// b : ""

class Status with Mappable {
  String? yellowBox;
  String? blueBox;
  Color? yellowBoxColor;
  Color? blueBoxColor;

  Status({String? yellowBox, String? blueBox}) {
    yellowBox = yellowBox;
    blueBox = blueBox;
  }

  Status.fromJson(dynamic json) {
    yellowBox = json["yellowBox"];
    blueBox = json["blueBox"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["yellowBox"] = yellowBox;
    map["blueBox"] = blueBox;
    return map;
  }

  @override
  void mapping(Mapper map) {
    map("yellowBox", yellowBox, (v) => yellowBox = v);
    map("blueBox", blueBox, (v) => blueBox = v);
    map("yellowBoxColor", yellowBoxColor, (v) {
      switch (yellowBox) {
        case '0':
          yellowBoxColor = Colors.white;
          break;
        case '1':
          yellowBoxColor = Colors.green;
          break;
        case '2':
          yellowBoxColor = Colors.orange;
          break;
        case '3':
          yellowBoxColor = Colors.red;
          break;
      }
    });
    map("blueBoxColor", blueBoxColor, (v) {
      switch (blueBox) {
        case '0':
          blueBoxColor = Colors.white;
          break;
        case '1':
          blueBoxColor = Colors.blue;
          break;
      }
    });
  }
}
