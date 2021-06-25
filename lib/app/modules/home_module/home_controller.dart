import 'dart:convert';

import 'package:feed/app/data/materiel.dart';
import 'package:feed/app/data/model/work_station_info.dart';
import 'package:feed/app/widgets/feed_item_info_widget/feed_item_info.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';
import 'package:workmanager/workmanager.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeController extends GetxController {
  // var _obj = ''.obs;
  //
  // set obj(value) => _obj.value = value;
  //
  // get obj => _obj.value;
  RxString modelVersion = ''.obs;
  RxInt index = 0.obs;
  int feedLength = 0;
  RxList materiels = [].obs;
  RxList rxInCarMateriels = [].obs;
  RxList feedItems = [].obs;
  List<Materiel> inCarMateriels = [];
  SunmiBarcodePlugin? sunmiBarcodePlugin = SunmiBarcodePlugin();
  void notify() {
    print('HomeController.notify');
    Workmanager().registerOneOffTask(
      "XXX",
      'test',
      initialDelay: Duration(seconds: 10),
    );
  }

  bool indexIncrease() {
    bool ret = false;
    addMaterielToCar(index.value);
    if (index < feedLength-1) {

      this.index++;
      ret = true;
    }



    return ret;
  }

  void addMaterielToCar(int index) {
    Materiel mmateriel = materiels.elementAt(index);
    if (!inCarMateriels.contains(mmateriel))
      inCarMateriels.add(materiels.elementAt(index));
  }

  String showInCarFeedItem() {
    print(jsonEncode(inCarMateriels));
    this.rxInCarMateriels.clear();
    this.rxInCarMateriels.addAll(this.inCarMateriels);
    return jsonEncode(inCarMateriels);
  }

  Future<void> initPlatformState() async {

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      modelVersion.value = (await sunmiBarcodePlugin!.getScannerModel()).toString();
    } on PlatformException {
      modelVersion.value = 'Failed to get model version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
    //
    //
    //   _modelVersion = modelVersion;

  }
  @override
  void onInit() async {
    super.onInit();
    final JsonCodec json = new JsonCodec();

    Mappable.factories = {Materiel: () => Materiel()};

    this.materiels.addAll(List<Materiel>.from(json
        .decode(
        """[{"sku": "5566", "name": "ABC", "locationCode":"D12" , "qty": "2", "unit":"box" },{"sku": "7788", "name": "YTR", "locationCode":"A07" , "qty": "6", "unit":"box" },{"sku": "9911", "name": "XCC", "locationCode":"B05" , "qty": "10", "unit":"box" }]""")
        .map(
            (data) => Mapper.fromJson(data).toObject<Materiel>())).toList());

    this.feedLength = materiels.length;

    //this.getAllPosts();
    print('HomeController=====>>>onInit');

    initPlatformState();
    sunmiBarcodePlugin!.onBarcodeScanned().listen((event) => print(event));
  }


}
