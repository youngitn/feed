import 'package:feed/app/modules/home_module/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingCarListView extends GetWidget<HomeController> {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: homeController.rxInCarMateriels.length,
          itemBuilder: (context, index) {
            return Card(
              //
              child: ListTile(
                leading: Icon(Icons.done,color: Colors.green,),
                title: Text(
                    'sku:${homeController.rxInCarMateriels.elementAt(index).sku}'),
                subtitle: Text(
                  'name:${homeController.rxInCarMateriels.elementAt(index).name}'
                  ' / location:${homeController.rxInCarMateriels.elementAt(index).locationCode}'
                  ' / qty:${homeController.rxInCarMateriels.elementAt(index).qty}'
                  ' / unit:${homeController.rxInCarMateriels.elementAt(index).unit}'
                        ),
                // trailing: Icon(Icons.done,color: Colors.green,),
              ),
            );
          },
        ));
  }
}
