import 'package:flutter/material.dart';

class  AppColors { 
  // static AppColors _instance = AppColors.internal();
  // AppColors.internal();
  // factory AppColors => _instance; 

  /// BLUE
  static final blueLightTeal = Color.fromRGBO(0, 171, 189, 1.0);
  static final facebookBlue = Color.fromRGBO(59, 89, 152, 1.0);

  /// WHITE
  static final white = Colors.white;

  /// GREY
  static final lightGrey = Colors.grey[200];

  /// ORANGE
  static final lightOrange = Colors.orange[300];

  /// BLACK
  static final lightBlack = Colors.black54;

  /// RED
  static final lightRed = Colors.red.shade500;
  static final red = Colors.red;

  //TRANSPARENT
  static final transparent = Colors.transparent;

  static final TextStyle textStyle = const TextStyle(
      color: const Color(0XFFFFFFFF),
      fontSize: 16.0,
      fontWeight: FontWeight.normal);

  static final ThemeData appTheme = new ThemeData(
    hintColor: Colors.white,
  );

  static final Color textFieldColor = const Color.fromRGBO(255, 255, 255, 0.1);

  static final Color primaryColor = const Color(0xFF00c497);

  static final TextStyle buttonTextStyle = const TextStyle(
      color: const Color.fromRGBO(255, 255, 255, 0.8),
      fontSize: 14.0,
      fontFamily: "Roboto",
      fontWeight: FontWeight.bold);
}
