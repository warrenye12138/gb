import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gb/common/res/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

typedef LoadingBuilder = Widget Function(BuildContext context, Widget? child);

class Loading {
  static LoadingBuilder init() {
    return FlutterSmartDialog.init();
  }

  static void show({
    String text = "",
    bool isClick = false,
  }) {
    SmartDialog.showLoading(
      maskColor: Colors.black.withOpacity(0.2),
      clickMaskDismiss: isClick,
      builder: (content) {
        return Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: AppColors.themeColor,
            size: 40,
          ),
        );
      },
    );
  }

  static Future<void> dismiss() async {
    await SmartDialog.dismiss();
  }

  static Future<void> toast(String text) async {
    await SmartDialog.showToast(text, alignment: Alignment.center);
  }
}
