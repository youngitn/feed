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
    this.id = id;
    this.type = type;
    this.note = note;
    this.status = status;
  }

  WorkStationInfo.fromJson(dynamic json) {
    this.id = json["id"];
    this.status = json["status"];
    this.note = json["note"];
    this.type = json["type"];
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
    this.yellowBox = yellowBox;
    this.blueBox = blueBox;
    this.yellowBoxColor = buildYellowBoxColor();
    this.blueBoxColor = buildBlueBoxColor();
  }

  Status.fromJson(dynamic json) {
    this.yellowBox = json["yellowBox"];
    this.blueBox = json["blueBox"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["yellowBox"] = this.yellowBox;
    map["blueBox"] = this.blueBox;
    return map;
  }

  Color buildBlueBoxColor() {
    switch (this.blueBox) {
      case '0':
        return Colors.white;

      case '1':
        return Colors.blue;
    }
    return Colors.white;
  }

  Color buildYellowBoxColor() {
    switch (this.yellowBox) {
      case '0':
        return Colors.white;
        break;
      case '1':
        return Colors.green;
        break;
      case '2':
        return Colors.orange;
        break;
      case '3':
        return Colors.red;
        break;
    }
    return Colors.white;
  }

  @override
  void mapping(Mapper map) {
    map("yellowBox", yellowBox, (v) =>  this.yellowBox = v);
    map("blueBox", blueBox, (v) =>  this.blueBox = v);
    map("yellowBoxColor", yellowBoxColor, (v) {
      this.yellowBoxColor = buildYellowBoxColor();
    });
    map("blueBoxColor", blueBoxColor, (v) {
      this.blueBoxColor = buildBlueBoxColor();
    });
  }
}
