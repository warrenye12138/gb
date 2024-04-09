import 'package:flutter/material.dart';
import 'package:gb/common/res/fonts.dart';
import 'colors.dart';
import 'dimens.dart';

class MSStyles {
  static TextStyle getTitleStyle(
      {double? sp,
      Color? color,
      double? letterSpacing,
      String? fontFamily,
      TextDecoration? decoration}) {
    return TextStyle(
        color: color,
        fontFamily: fontFamily ?? '',
        fontSize: sp ?? sp21,
        decoration: decoration ?? TextDecoration.none,
        letterSpacing: letterSpacing ?? 0.6);
  }

  static TextStyle getTipStyle() {
    return TextStyle(
        fontFamily: FFontFamily.fontLight,
        fontSize: sp12,
        color: AppColors.greyColor);
  }

  static TextStyle likeStyle() {
    return TextStyle(
        fontFamily:FFontFamily.fontLight,
        fontSize: sp16,
        color: AppColors.modelGrayColor);
  }
}
