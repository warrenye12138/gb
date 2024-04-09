import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///屏幕缩放插件
class Su {
  ///加载
  static load() async {
    await ScreenUtil.ensureScreenSize();
  }

  ///静态初始化方法
  static init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    ); //支持分屏
  }

  static double get divider => h(1);

  /// 页面内边距
  static EdgeInsetsGeometry get app {
    return EdgeInsets.symmetric(
      horizontal: ph(),
      vertical: pv(),
    );
  }

  /// 页面水平内边距
  static ph() => w(16);

  /// 页面垂直内边距
  static pv() => w(16);

  ///列表item水平内边距
  static lhp() => w(16);

  ///列表item垂直内边距
  static lvp() => w(16);

  /// 获取 计算后的字体
  static sp(double v) {
    return v.sp;
  }

  /// 获取 计算后的宽度
  static w(double value) {
    return value.w;
  }

  /// 获取 计算后的高度
  static h(double value) {
    return value.h;
  }

  /// 根据宽度或高度中的较小者进行调整
  static r(double value) {
    return value.r;
  }

  /// 获取 计算后的屏幕高度
  static double get sh {
    return 1.sh;
  }

  /// 获取 计算后的屏幕高度
  static double get sw {
    return 1.sw;
  }

  static double? get scale {
    return ScreenUtil().pixelRatio;
  }

  static double get textScaleFactor {
    return ScreenUtil().textScaleFactor;
  }

  ///顶部导航栏高度= 状态栏高度 + Appbar高度
  static double get topBarHeight {
    return ScreenUtil().statusBarHeight + bh;
  }

  static double get bh {
    return kToolbarHeight;
  }

  static double get tsh {
    return ScreenUtil().statusBarHeight;
  }

  static double get bsh {
    return ScreenUtil().bottomBarHeight;
  }
}
