import 'package:feed/app/modules/home_module/home_controller.dart';
import 'package:feed/app/routes/app_pages.dart';

import 'package:feed/app/widgets/shopping_car_list_view_widget/shopping_car_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class ShoppingCarPage extends GetView {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("shopping car"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ShoppingCarListView(),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          child: TextButton(
            child: Icon(Icons.local_shipping, color: Colors.black),
            onPressed: () {
              Get.defaultDialog(
                title: "進行系統過帳",
                middleText: "是否確定送出資料並列印二維條碼貼紙?",
                textConfirm: '確定',
                textCancel: '取消',
                onConfirm: () {
                  Get.back();
                  Get.defaultDialog(
                    textConfirm: '確定',
                    onConfirm: ()=>Get.toNamed(Routes.HOME),
                    title: "已進行系統過帳&條碼列印",
                    middleText: "按下確定後返回首頁",
                  );

                },
              );
              //ShoppingCarPage
            },
          ),
        ),
      ),
    );
  }
}
