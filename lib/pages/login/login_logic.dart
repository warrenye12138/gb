import 'package:flutter/material.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginLogic extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FirebaseAuth currentUser = FirebaseAuth.instance;

  void toSignInPage() {
    Get.toNamed(AppRoutes.pathToSignIn);
  }

  Future<void> logIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (FirebaseAuth.instance.currentUser != null) {
          // Get.offAllNamed(AppRoutes.pathToHome);
          ApiService.instance.onInit();
          // print(FirebaseAuth.instance.currentUser?.uid);
        } else {
          Get.snackbar("登录失败", "密码或邮箱错误");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("登录失败", "用户不存在");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("登录失败", "密码或邮箱错误");
        } else if (e.code == "invalid-credential") {
          Get.snackbar("登录失败", "用户不存在");
        }
      }
      emailController.clear();
      passwordController.clear();
    } else {
      Get.snackbar("登录失败", "密码或邮箱错误");
    }
  }

  void textClear(TextEditingController controller) {
    controller.clear();
  }
}
