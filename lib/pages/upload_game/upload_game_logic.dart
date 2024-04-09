import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/third_party/toast.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UploadGameLogic extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var gameImageFile = Rxn<File>();
  var gameId = const Uuid().v4();
  var topicId = const Uuid().v4();

  String uid = ApiService.instance.getUid();

  void selectPhoto() async {
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
        gameImageFile.value = file;
      }
    }
  }

  //上传游戏
  void uploadNewGame() async {
    KeyboardBack.keyboardBack();
    Loading.show();
    // MyLoading.instance.showLoading();
    if (nameController.text.isEmpty) {
      Loading.toast('上传失败，请输入游戏名');
      Loading.dismiss();
      // MyLoading.instance.dismiss();
    } else {
      uploadGameData(nameController.text,
          description: descController.text, image: gameImageFile.value);
      Loading.dismiss();
      // MyLoading.instance.dismiss();
    }
  }

  //上传游戏数据
  Future<void> uploadGameData(
    String gameName, {
    String? description,
    File? image,
  }) async {
    KeyboardBack.keyboardBack();
    try {
      String? imageUrl;
      if (image != null) {
        String name = const Uuid().v4();
        imageUrl = await ApiService.instance.goUploadImage(
            image, "${DefaultText.gameIcon}${name.toLowerCase()}");
      }
      FirebaseFirestore.instance
          .collection(DefaultText.games)
          .doc('${gameName}_$gameId')
          .set({
        'gameName': gameName,
        'gameId': gameId,
        'description': description ?? '',
        'gameIcon': imageUrl ?? '',
      });
    } catch (e) {}
    await postFirstTopic(gameName, gameId);
    await Loading.toast('上传成功');
    Get.back();
  }

  //默认发布第一条
  Future<void> postFirstTopic(String? newGameName, String gameId) async {
    DateTime uploadTime = DateTime.now();
    Map<String, dynamic> param = {};

    param['gameId'] = gameId;
    param['topicId'] = topicId;
    param['uid'] = uid;
    param['name'] = ApiService.instance.getName();
    param['time'] =
        '${uploadTime.year}-${uploadTime.month}-${uploadTime.day} ${uploadTime.hour}:${uploadTime.minute}';
    param['preciseTime'] = DateTime.now().millisecondsSinceEpoch;
    param['content'] =
        'This is the first topic! Welcome to join us and share your opinions!';
    param['images'] = [];
    param['collect'] = 0;
    param['comment'] = 0;
    param['good'] = 0;
    param['middle'] = 0;
    param['bad'] = 0;
    param['type'] = 'first-text';

    try {
      await ApiService.instance
          .goPublicTopic(gameId: gameId, topicId: topicId, param: param);
      await ApiService.instance
          .goMyTopic(topicId: topicId, uid: uid, param: param);
      await ApiService.instance
          .publicOpinion(gameId: gameId, topicId: topicId, state: 0);
    } catch (e) {}
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    super.onClose();
  }
}
