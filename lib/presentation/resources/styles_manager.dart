import 'package:flutter/material.dart';

import 'fonts_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontFamily: FontsFamilyManager.fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color);
}

// light style

TextStyle getLightTextStyle(
    {double fontSize = FontsSizeManager.s12, Color? color}) {
  return _getTextStyle(fontSize, FontsWeightManager.light, color!);
}

// regular style

TextStyle getRegularTextStyle(
    {double fontSize = FontsSizeManager.s12, Color? color}) {
  return _getTextStyle(fontSize, FontsWeightManager.regular, color!);
}

// meduim style

TextStyle getMeduimTextStyle(
    {double fontSize = FontsSizeManager.s12, required Color color}) {
  return _getTextStyle(fontSize, FontsWeightManager.meduim, color);
}

// semiBold style

TextStyle getSemiBoldTextStyle(
    {double fontSize = FontsSizeManager.s12, required Color color}) {
  return _getTextStyle(fontSize, FontsWeightManager.semiBold, color);
}

// bold style

TextStyle getBoldTextStyle(
    {double fontSize = FontsSizeManager.s12, required Color color}) {
  return _getTextStyle(fontSize, FontsWeightManager.bold, color);
}
