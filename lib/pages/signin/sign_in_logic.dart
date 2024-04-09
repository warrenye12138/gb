import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:username/username.dart';

class SignInLogic extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController makeSureController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser;
  String randomName = Username.cn().fullname;
  final myUserId = FirebaseAuth.instance.currentUser?.uid;
  FirebaseFirestore auth = FirebaseFirestore.instance;

  Future<void> signin() async {
    KeyboardBack.keyboardBack();

    if (emailController.text.isNotEmpty) {
      if (passwordController.text.isNotEmpty &&
          makeSureController.text.isNotEmpty) {
        if (makeSureController.text == passwordController.text) {
          try {
            final credential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            if (credential.user != null) {
              FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );

              Map<String, String> param = {};
              param['uid'] = credential.user!.uid;
              param['avatar'] = '';
              param['name'] = randomName;
              param['email'] = emailController.text;
              param['password'] = passwordController.text;
              param['identity'] = 'normal user';
              emailController.clear();
              passwordController.clear();
              await auth
                  .collection(DefaultText.users)
                  .doc(credential.user!.uid)
                  .set(param);
              ApiService.instance.onInit();
              Get.snackbar("提示", "注册成功");
              Logger().d("注册成功");
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              Logger().d("密码太弱");
            } else if (e.code == 'invalid-email') {
              Logger().d("邮箱格式错误");
            } else if (e.code == 'email-already-in-use') {
              Logger().d("邮箱已存在");
            }
          }
        } else {
          makeSureController.clear();
          Get.snackbar('提示', '  确认密码错误或不能为空');
        }
      } else {
        passwordController.clear();
        Get.snackbar('提示', '  密码错误或不能为空');
      }
    } else {
      emailController.clear();
      Get.snackbar("提示", "邮箱错误或不能为空");
    }
  }

  void back() {
    KeyboardBack.keyboardBack();
    Get.back();
  }

  void textClear(TextEditingController controller) {
    controller.clear();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    makeSureController.dispose();
  }
}
