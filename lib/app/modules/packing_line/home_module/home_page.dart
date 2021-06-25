import 'package:feed/app/theme/app_colors.dart';
import 'package:feed/app/widgets/packing_line_layout/packing_line_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:let_log/let_log.dart';

import 'home_controller.dart';

/**
 * 使用到SingleTickerProviderStateMixin 故使用StatefulWidget寫法
 * */

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomeController homeController = Get.find();

  // @override
  // void initState() {
  //   tabController = new TabController(length: 3, vsync: this);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    double circleSize = 50;
    if (context.isLandscape || context.isPortrait) {
      //homeController.stopUpdateWorkStationStatusCycleOperation();
      //homeController.startUpdateWorkStationStatusCycleOperation();
      print("homeController.buildLayout();");
    }
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.grey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Icon(Icons.error, size: 60),
              ),
              Card(
                title: '檢視Logger',
                icon: Icons.fiber_smart_record,
                onTap: () {
                  Get.to(() => Logger());
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          homeController.stopUpdateWorkStationStatusCycleOperation();
        },
      ),
      appBar: AppBar(
        title: Text('包裝線待補料狀態'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PackingLineLayout(),
          ),
          BottomAppBar(
            color: backgroundColor,
            child: Row(
              // 平均分配空間
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text('燈號說明=>   '),
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(' : 急迫'),
                    SizedBox(
                      width: 60,
                    ),
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: new BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(' : 正常'),
                    SizedBox(
                      width: 60,
                    ),
                    Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: new BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(' : 預警'),
                    SizedBox(
                      width: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback onTap;

  const Card({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.lightBlue,
        width: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 10),
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),

            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
