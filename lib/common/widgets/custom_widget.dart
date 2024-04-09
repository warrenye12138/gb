import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb/common/res/res.dart';

/// 文本
class SimpleText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final int lineNumber;
  final double? height;
  final TextAlign textAlign;
  final String? fontName;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;

  const SimpleText({
    super.key,
    required this.text,
    this.textColor = Colors.black87,
    this.fontSize,
    this.lineNumber = 0,
    this.height,
    this.textAlign = TextAlign.center,
    this.fontName,
    this.fontWeight,
    this.textDecoration,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: lineNumber <= 0 ? 999 : lineNumber,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      strutStyle: StrutStyle(
        fontSize: fontSize ?? 16,
        leading: 0,
        forceStrutHeight: height != null ? false : true,
      ),
      style: TextStyle(
        color: textColor,
        height: height,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FFont.normal,
        fontFamily: fontName,
        decoration: textDecoration,
        fontStyle: fontStyle,
      ),
    );
  }
}

/// 圆角按钮
class CustomRadiusButton extends StatelessWidget {
  final String title;
  final double? iconWidth;
  final double? interval;
  final double? fontSize;
  final double? width;
  final double? height;
  final double? columHeight;
  final double paddingX;
  final Color textColor;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final double? radius;
  final Gradient? gradient;
  final BoxBorder? border;
  final Function() tap;

  /// 圆角按钮
  const CustomRadiusButton({
    super.key,
    required this.title,
    this.iconWidth,
    this.interval,
    this.width,
    this.height,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.red,
    required this.tap,
    this.fontSize,
    this.fontWeight = FFont.normal,
    this.radius,
    this.columHeight,
    this.gradient,
    this.paddingX = 0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: tap,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        width: width,
        height: height ?? 48,
        padding: EdgeInsets.symmetric(horizontal: paddingX),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          border: border,
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? (height ?? 48) / 2),
          ),
        ),
        child: Center(
          child: SimpleText(
            text: title,
            textColor: textColor,
            fontWeight: fontWeight,
            fontSize: fontSize ?? 16,
            textAlign: TextAlign.center,
            lineNumber: 1,
            height: columHeight,
          ),
        ),
      ),
    );
  }
}

///去掉滑动波纹
class CusBehavior extends ScrollBehavior {
  final ScrollController controller;

  const CusBehavior(this.controller);

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return super.buildOverscrollIndicator(context, child,
        ScrollableDetails(direction: axisDirection, controller: controller));
  }
}
