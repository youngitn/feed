import 'dart:convert';
import 'dart:developer';

import 'package:feed/app/data/model/work_station_info.dart';
import 'package:feed/app/modules/packing_line/home_module/home_controller.dart';

import 'package:feed/app/service/http_service.dart';
import 'package:feed/app/service/http_service_impl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:let_log/let_log.dart';
import 'package:object_mapper/object_mapper.dart';

class WorkStationRepo {
  HttpService? _httpService = HttpServiceImpl();

  String json = """
      [
      {"id":"A01","note":"備註","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"A02","note":"note","status":{"yellowBox":"3","blueBox":"0"}},
      {"id":"A03","note":"備註","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"A04","status":{"yellowBox":"3","blueBox":"0"}},
      {"id":"A05","note":"note","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"A06","note":"note","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"A07","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"A08","type":"平台單","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"A09","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"A10","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"A11","status":{"yellowBox":"3","blueBox":"0"}},
      {"id":"A12","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B01","status":{"yellowBox":"3","blueBox":"0"}},
      {"id":"B02","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B03","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"B04","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B05","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B06","type":"平台單","note":"note","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"B07","type":"平台單","note":"備註","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"B08","type":"平台單","note":"備註","status":{"yellowBox":"1","blueBox":"0"}},  
      {"id":"C01","type":"平台單","note":"備註","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C02","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C03","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C04","status":{"yellowBox":"0","blueBox":"0"}},
      {"id":"C05","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"C06","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"C07","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"C08","status":{"yellowBox":"1","blueBox":"0"}},
     {"id":"D01","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D02","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D03","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D04","note":"note","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D05","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"D06","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D07","note":"備註","type":"平台單","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"D08","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D09","status":{"yellowBox":"1","blueBox":"0"}},
      {"id":"D10","note":"備註","status":{"yellowBox":"2","blueBox":"0"}},
      {"id":"D11","status":{"yellowBox":"3","blueBox":"0"}},
      {"id":"D12","note":"備註","status":{"yellowBox":"2","blueBox":"0"}}
      
      
      ]
      """;

  List<WorkStationInfo> processBlueBoxStatus(List<WorkStationInfo> dataObjs) {
    ///取得bluebox持久資料
    final box = GetStorage();
    Map<String, dynamic> map = Map<String, dynamic>();
    List<WorkStationInfo> nowList = [];
    if (box.read('blueBoxMap') != null) {
      map = box.read('blueBoxMap');

      //重組List<WorkStationInfo>
      for (WorkStationInfo w in dataObjs) {
        if (map[w.id] != null) {
          // print('${w.id} ${map[w.id]!.toString()}');
          // print('${w.status!.yellowBox}');

          //dataObjs[dataObjs.indexOf(w)] =;
          nowList.add(WorkStationInfo(
              id: w.id,
              type: w.type,
              note: w.note,
              status: Status(
                yellowBox:
                    w.status!.yellowBox!.isEmpty ? "0" : w.status!.yellowBox,
                blueBox: map[w.id].toString(),
              )));
        } else {
          nowList.add(w);
        }
      }
    } else {
      nowList = dataObjs;
    }

    nowList.sort((a, b) => a.id!.compareTo(b.id!));
    return nowList;
  }

  Future<List<WorkStationInfo>> getAll() async {
    // TODO: implement getNewsHeadline

    try {
      // Logger.net('https://jsonplaceholder.typicode.com/todos/1', type: "http.get");
      //
      final response = await _httpService!.getRequest("https://www.google.com");
      // print(response.data);
      // Logger.endNet("https://jsonplaceholder.typicode.com/todos/1");

      Mappable.factories = {
        WorkStationInfo: () => WorkStationInfo(),
        Status: () => Status()
      };
      List<WorkStationInfo> dataObjs = [];

      dataObjs = List<WorkStationInfo>.from(jsonDecode(this.json)
              .map((data) => Mapper.fromJson(data).toObject<WorkStationInfo>()))
          .toList();
      dataObjs = processBlueBoxStatus(dataObjs);

      return Future.value(dataObjs);
    } on Exception catch (e) {
      Logger.error(e);
      print(e);
      return [];
    }
  }
}
