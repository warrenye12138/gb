import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gb/common/res/colors.dart';
import 'package:gb/common/res/dimens.dart';
import 'package:gb/common/res/fonts.dart';
import 'package:gb/common/res/gaps.dart';
import 'package:gb/common/res/styles.dart';
import 'package:get/get.dart';

//showActionSheet函数，用于显示一个底部弹出的操作菜单。
class ActionSheetItem {
  final String title;
  final VoidCallback action;

  ActionSheetItem({required this.action, required this.title});
}

void showActionSheet({required List<ActionSheetItem> actions}) {
  List<Widget> items = List.empty(growable: true);
  double height = h10;
  for (var element in actions) {
    items.add(
      h10.lbh,
    );
    items.add(
      SliverToBoxAdapter(
        child: GestureDetector(
          key: ValueKey(element.title),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: h34,
            alignment: Alignment.center,
            width: ScreenUtil().screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  element.title,
                  style: MSStyles.getTitleStyle(
                      color: AppColors.themeText,
                      sp: sp15,
                      fontFamily: FFontFamily.fontLight),
                )
              ],
            ),
          ),
          onTap: () {
            if (Get.isBottomSheetOpen == true) {
              Get.until((route) => Get.isBottomSheetOpen == false);
            }
            element.action.call();
          },
        ),
      ),
    );
    height = height + h10 + h34;
  }

  items.add(
    h10.lbh,
  );
  height = height + h10;
  items.add(
    SliverToBoxAdapter(
      child: Divider(
        height: h1,
      ),
    ),
  );
  items.add(
    SliverToBoxAdapter(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        key: const ValueKey('CANCEL'),
        child: Container(
          height: h40,
          alignment: Alignment.center,
          width: ScreenUtil().screenWidth,
          child: Text(
            'CANCEL',
            style: MSStyles.getTitleStyle(
                color: AppColors.themeText,
                sp: sp14,
                fontFamily: FFontFamily.fontLight),
          ),
        ),
        onTap: () {
          if (Get.isBottomSheetOpen == true) {
            Get.until((route) => Get.isBottomSheetOpen == false);
          }
        },
      ),
    ),
  );
  height = height + h40;

  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(h8),
            topRight: Radius.circular(h8),
          ),
          color: AppColors.colorWhite),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: h20),
      child: CustomScrollView(
        slivers: items,
      ),
    ),
  );
}
