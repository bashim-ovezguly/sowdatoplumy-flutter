import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';

class CustomText {
  static const appBarText =
      TextStyle(color: CustomColors.appColorWhite, fontSize: 20);
  static const itemText = TextStyle(fontSize: 12, color: CustomColors.appColor);
  static const itemTextBold = TextStyle(
      fontSize: 14,
      color: CustomColors.appColor,
      overflow: TextOverflow.clip,
      fontWeight: FontWeight.bold);

  static const size_16_black54 =
      TextStyle(fontSize: 14, color: CustomColors.appColorBlack54);
  static const size_16 = TextStyle(fontSize: 14, color: CustomColors.appColor);
  static const size_c = TextStyle(
      fontSize: 14, color: CustomColors.appColor, fontWeight: FontWeight.bold);
}
