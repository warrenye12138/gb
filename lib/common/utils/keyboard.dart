import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KeyboardBack {
  static FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  static void keyboardBack() {
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
