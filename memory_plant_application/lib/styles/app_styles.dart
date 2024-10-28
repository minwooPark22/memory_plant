import 'package:flutter/material.dart';

Color primary = const Color(0xFFA6D1FA);

class AppStyles {
  static Color primaryColor = primary;
  // # 추가하고싶은거 추가
  static Color textColor = const Color(0xFF3b3b3b);

  static TextStyle textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor);
}
