import 'package:animator/animator.dart';
import 'package:feed/app/modules/packing_line/home_module/home_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorAnimateContainer extends GetWidget<HomeController>{

  ColorAnimateContainer(this.boxColor);
  final Color? boxColor;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimateWidget(
      duration: const Duration(seconds: 1),
      reverseDuration: 5.milliseconds(),// use extension
      //curve: Curves.fastOutSlowIn,
      //reverseCurve: Curves.bounceInOut,
      cycles: 0,
      builder: (context, animate) {
        final width = animate.fromTween(
              (currentValue) => Tween(
            begin: 30.0,
            end: 30.0,
          ),
        );
        final height = animate.fromTween(
              (currentValue) => 30.0.tweenTo(30.0), //use of extension
          'height',
        );

        final alignment = animate.fromTween(
              (currentValue) => AlignmentGeometryTween(
            begin: Alignment.center,
            end: AlignmentDirectional.topCenter,
          ),
        );

        final Color? color = animate.fromTween(
              (currentValue) => Colors.white.tweenTo(this.boxColor!),
          'height',
        );

        return Container(
          width: width,
          height: height,
          color: color,
          alignment: alignment,
          //child: const FlutterLogo(size: 75),
        );
      },
    );
  }

}