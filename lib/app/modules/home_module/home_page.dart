import 'package:feed/app/data/materiel.dart';

import 'package:feed/app/routes/app_pages.dart';

import 'package:feed/app/widgets/feed_item_info_widget/feed_item_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:feed/app/modules/home_module/home_controller.dart';
/**
 * 使用到SingleTickerProviderStateMixin 故使用StatefulWidget寫法
 * */

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());

  // @override
  // void initState() {
  //   tabController = new TabController(length: 3, vsync: this);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('補料作業'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.notify();
      //   },
      //   tooltip: 'test',
      //   child: Icon(Icons.circle_notifications),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          if (!homeController.indexIncrease()) {
            Get.defaultDialog(
              title: "已達最後一筆",
              content:Text(
                  '''取料完成 料號:${homeController.materiels.elementAt(homeController.index.value).sku}\n即將轉換頁面至已取料列表
                  ''')
                  ,
              onConfirm: () {
                Get.back();
                homeController.showInCarFeedItem();
                Get.toNamed(Routes.SHOPPING_CAR);

              },
            );


          } else {
            Get.defaultDialog(
              title: "取料完成",
              middleText:
                  "料號:${homeController.materiels.elementAt(homeController.index.value - 1).sku} ",
            );
          }

          print('index=${homeController.index}');

          //tabController.animateTo(index);
        },
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: FeedItemInfo(),

      // 使用 BottomNavigationBar
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          child: TextButton(
            child: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              homeController.showInCarFeedItem();
              Get.toNamed(Routes.SHOPPING_CAR);
              //ShoppingCarPage
            },
          ),
        ),
      ),
    );
  }
}
