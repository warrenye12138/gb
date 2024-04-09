import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SplashLogic extends GetxController {
  var logger = Logger();

  Timer timer = Timer(const Duration(seconds: 0), () {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        // print('用户is currently signed out!');
        Logger().d('用户is currently signed out!a');
        Get.offAllNamed(AppRoutes.pathToLogin);
      } else {
        Logger().d('用户存在 signed in!a');
        Get.offAllNamed(AppRoutes.pathToHome);
      }
    });
  });
  @override
  void onInit() {
    splashTime();
    super.onInit();
  }

  void get() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        Logger().d('用户is currently signed out!q');
        Get.offAllNamed(AppRoutes.pathToLogin);
      } else {
        Logger().d('用户存在 signed in!q');
        Get.offAllNamed(AppRoutes.pathToHome);
      }
    });
  }

  void splashTime() {
    timer;
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
