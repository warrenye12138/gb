import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/third_party/toast.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:gb/common/widgets/image_big.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UploadTopicLogic extends GetxController {
  TextEditingController content = TextEditingController();

  ///游戏id
  String gameId = '';

  RxBool allowUpload = false.obs;

  ///照片
  List<AssetEntity> imageAssetEntity = [];
  var imageFiles = <File>[].obs;

  @override
  void onInit() {
    gameId = Get.arguments['gameId'];
    super.onInit();
  }

  ///点击选择图片
  Future<void> clickImagePick() async {
    KeyboardBack.keyboardBack();
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(
        selectedAssets: imageAssetEntity,
        maxAssets: 9,
        requestType: RequestType.image,
        textDelegate: const EnglishAssetPickerTextDelegate(),
      ),
    );
    if (result != null && result.isNotEmpty) {
      imageFiles.value = await assetEntityChangeFile(result);
      imageAssetEntity = result;
    }
  }

  ///对象转换
  Future<List<File>> assetEntityChangeFile(List<AssetEntity> list) async {
    List<File> files = [];
    await Future.forEach(list, (AssetEntity assetEntity) async {
      File? file = await assetEntity.file;
      if (file != null) {
        files.add(file);
      }
    });
    return files;
  }

  ///删除已选图片
  void deleteImage(int index) {
    imageFiles.removeAt(index);
    imageAssetEntity.removeAt(index);
  }

  ///点击图片
  void clickImage(int index) {
    ImageBigShow.showImages(imageFiles, index: index);
  }

  ///发表话题
  void postTopic() async {
    KeyboardBack.keyboardBack();
    Loading.show();
    var topicId = const Uuid().v4();
    String userFileName = topicId;
    List<String> images = [];
    DateTime uploadTime = DateTime.now();

    images = await uploadImagesToFirebase(userFileName);

    Map<String, dynamic> param = {};
    param['gameId'] = gameId;
    param['topicId'] = topicId;
    param['uid'] = ApiService.instance.getUid();
    param['name'] = ApiService.instance.getName();
    param['time'] =
        '${uploadTime.year}-${uploadTime.month}-${uploadTime.day} ${uploadTime.hour}:${uploadTime.minute}';
    param['preciseTime'] = DateTime.now().millisecondsSinceEpoch;
    param['content'] = content.text;
    param['images'] = images.isNotEmpty ? images.map((e) => e).toList() : [];
    param['collect'] = 0;
    param['comment'] = 0;
    param['good'] = 0;
    param['middle'] = 0;
    param['bad'] = 0;
    param['type'] = images.isNotEmpty ? 'image' : 'text';

    try {
      await ApiService.instance
          .goPublicTopic(gameId: gameId, topicId: topicId, param: param);
      await ApiService.instance.goMyTopic(
          topicId: topicId, uid: ApiService.instance.getUid(), param: param);
      await ApiService.instance
          .publicOpinion(gameId: gameId, topicId: topicId, state: 0);
      Loading.dismiss();
      await Loading.toast("Add successfully🎉!");
      content.text = '';
      imageFiles.value = [];

      Get.back();
    } catch (_) {
      Loading.dismiss();
      await Loading.toast("Add failure");
    }
  }

  /// 上传照片
  Future<List<String>> uploadImagesToFirebase(String imageName) async {
    List<String> list = [];
    if (imageFiles.isEmpty) return list;
    list = await ApiService.instance
        .goUploadGamesDocument(imageFiles, DefaultText.topicImages, imageName);
    return list;
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    content.dispose();
    super.onClose();
  }
}
