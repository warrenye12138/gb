import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/third_party/toast.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EditProfileLogic extends GetxController {
  UserEntity user = ApiService.instance.userInfo ?? UserEntity();
  TextEditingController userName = TextEditingController();
  var avatar = Rxn<File>();

  //选择头像
  void selectAvatar() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
        textDelegate: EnglishAssetPickerTextDelegate(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      final asset = result[0];
      final file = await asset.file;
      if (file != null) {
        avatar.value = file;
      }
    }
  }

  //上传信息
  void uploadInfo() async {
    KeyboardBack.keyboardBack();
    if (userName.text.isNotEmpty) {
      String? imageUrl;

      imageUrl = await ApiService.instance
          .goUploadImage(avatar.value, "${DefaultText.avatar}${user.uid!}");

      Map<String, String> param = {};
      param['uid'] = user.uid!;
      param['avatar'] = imageUrl ?? user.avatar!;
      param['name'] = userName.text;
      param['email'] = user.email!;
      param['password'] = user.password!;
      param['identity'] = 'normal user';

      FirebaseFirestore.instance
          .collection(DefaultText.users)
          .doc(user.uid)
          .set(param);
      userName.clear();
      ApiService.instance.onInit();
      Get.offAllNamed(AppRoutes.pathToHome, arguments: {'index': 1});
    } else {
      Loading.toast('请输入昵称');
    }
  }

  @override
  void onClose() {
    avatar.close();
    userName.dispose();
    super.onClose();
  }
}
