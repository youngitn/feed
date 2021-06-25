import 'package:flutter/material.dart';
import 'app_colors.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

final ThemeData appThemeData = ThemeData(
  //primarySwatch: Colors.blue,
  //visualDensity: VisualDensity.adaptivePlatformDensity,

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: primaryColor,
  ),

  bottomAppBarColor: primaryColor,
  appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
    color: Colors.black,
  )),
  primaryIconTheme: IconThemeData(color: primaryColor),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
    ),
  ),

  ///輸入欄位主題
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey,
//border: InputBorder.none,
    enabledBorder: const OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
    ),
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: backgroundColor),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(color: primaryColor)),
  ),

  scaffoldBackgroundColor: backgroundColor,
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSwatch(
//primaryColorDark:Color.fromRGBO(68, 186, 181, 1) ,
          )
      .copyWith(
    secondary: secondaryColor,
  ),
  textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
);
