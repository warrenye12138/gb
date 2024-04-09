import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/third_party/firebase_db.dart';
import 'package:gb/common/third_party/firebase_storage.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ApiService extends GetxService {
  User? currentUser;
  static ApiService get instance => Get.find();
  FirebaseFirestore? userRef = FirebaseFirestore.instance;
  UserEntity? userInfo;
  @override
  void onInit() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      var aaa = await userRef!
          .collection(DefaultText.users)
          .where('uid', isEqualTo: currentUser!.uid)
          .get();
      if (aaa.docs.isNotEmpty) {
        userInfo = UserEntity.fromJson(aaa.docs.first.data());
      }
    }
    super.onInit();
  }

  Future<String?> goUploadImage(File? file, String path) async {
    if (file == null) return '';
    String? url = await FirebaseStorageManage.uploadImage(file, path);
    return url;
  }

  ///发表话题
  Future<void> goPublicTopic({
    required String gameId,
    required String topicId,
    required Map<String, dynamic> param,
  }) async {
    await FirebaseDbManage.publicTopic(gameId, topicId, param);
  }

  ///记录发布
  Future<void> goMyTopic({
    required String uid,
    required String topicId,
    required Map<String, dynamic> param,
  }) async {
    await FirebaseDbManage.publicMyTopic(uid, topicId, param);
  }

  ///删除话题
  Future<void> deleteTopic(TopicModel model) async {
    if (model.gameId == null || model.topicId == null) {
      Logger().d('No such document');
      return;
    }

    try {
      //删除话题内容
      await _deleteTopic(model.gameId!, model.topicId!);
      //删除我的发布
      await _deleteMyPublic(ApiService.instance.getUid(), model.topicId!);
      //删除所有收藏
      // await _deleteTopicAllCollect(
      //     model.domainId!, model.gameId!, model.topicId!);
      // //删除评论
      // await _deleteComment(model.domainId!, model.gameId!, model.topicId!);
      //删除评价
      await deleteOpinion(model.gameId!, model.topicId!, model.uid!);
      //删除media
      await _deleteMyimages(model.gameId!, model.topicId!);
      // await Loading.dismiss();
      Logger().d('Success to delete');
    } catch (e) {
      // await Loading.dismiss();
      Logger().d('Success to delete');
    }
  }

  //评价话题
  Future<void> publicOpinion({
    required String gameId,
    required String topicId,
    required int state,
  }) async {
    KeyboardBack.keyboardBack();
    String uid = ApiService.instance.getUid();
    final topicRef = FirebaseFirestore.instance
        .collection(DefaultText.opinions)
        .doc(DefaultText.topics)
        .collection(gameId)
        .doc(topicId);

    final topicDetailRef = FirebaseFirestore.instance
        .collection(DefaultText.topics)
        .doc(DefaultText.topics)
        .collection(gameId)
        .doc(topicId);

    final usersOpinion = FirebaseFirestore.instance
        .collection(DefaultText.opinions)
        .doc(DefaultText.users)
        .collection(uid)
        .doc(topicId);

    Map<String, dynamic> param = {
      'uid': uid,
      'topicId': topicId,
      'gameId': gameId,
      'time': DateTime.now().millisecondsSinceEpoch,
      'state': state,
    };
    List<String> opinions = ['', 'good', 'middle', 'bad'];
    topicOpinion(topicRef, uid, opinions[state], param);
    updateUserOpinion(usersOpinion, topicId, state, gameId);

    //更新topic评价个数
    for (String i in opinions) {
      if (i != '') {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          // final topicSnapshot = await transaction.get(topicDetailRef);
          int number = await getOpinionNumber(topicRef, i);
          transaction.update(topicDetailRef, {i: number});
        });
      }
    }
  }

//获取topic评价个数
  Future<int> getOpinionNumber(
      DocumentReference<Map<String, dynamic>> topicRef, String opinion) async {
    QuerySnapshot querySnapshot = await topicRef.collection(opinion).get();
    int count = querySnapshot.size;
    // Loading.dismiss();
    return count;
  }

  //更新topic下有的评价
  void topicOpinion(DocumentReference<Map<String, dynamic>> topicRef, String id,
      String opinion, Map<String, dynamic> param) {
    String setOpinion = '';
    List<String> delete = [];
    if (opinion == 'good' || opinion == 'middle' || opinion == 'bad') {
      setOpinion = opinion;
      delete = deleteExcept(opinion);
    } else {
      delete = deleteExcept('');
    }
    if (setOpinion != '') {
      topicRef.collection(setOpinion).doc(id).set(param);
    }
    for (String i in delete) {
      topicRef.collection(i).doc(id).delete();
    }
  }

  ///更新用户自己评价过的topic
  void updateUserOpinion(DocumentReference<Map<String, dynamic>> usersOpinion,
      String topicId, int state, String gameId) {
    Map<String, dynamic> param = {
      'uid': ApiService.instance.getUid(),
      'topicId': topicId,
      'gameId': gameId,
      'time': DateTime.now().millisecondsSinceEpoch,
      'state': state,
    };
    usersOpinion.set(param);
  }

  //删除用户评价过的
  List<String> deleteExcept(String opinion) {
    List<String> opinions = ['good', 'middle', 'bad'];
    List<String> delete = [];
    for (String i in opinions) {
      if (i != opinion) {
        delete.add(i);
      }
    }
    return delete;
  }

  ///上传话题图片
  Future<List<String>> goUploadGamesDocument(
      List<File> files, String path, String name) async {
    List<String> imageUrls = [];
    String? imageUrl = '';
    int count = 1;
    await Future.forEach(
      files,
      (file) async {
        imageUrl =
            await FirebaseStorageManage.uploadDocument(file, path, name, count);
        if (imageUrl != null) {
          imageUrls.add(imageUrl!);
          count += 1;
        }
      },
    );

    return imageUrls;
  }

  ///判断话题文档是否存在
  Future<bool> topicIsExist(String gameId, String topicId) async {
    var topicDr = FirebaseFirestore.instance
        .collection(DefaultText.topics)
        .doc(DefaultText.topics)
        .collection(gameId)
        .doc(topicId);
    bool isExist = false;
    try {
      var newDoc = await topicDr.get();
      if (newDoc.data() != null) {
        isExist = true;
      }
    } catch (_) {}
    return isExist;
  }

  getUid() {
    return userInfo!.uid ?? '';
  }

  getName() {
    return userInfo!.name ?? '';
  }
}

deleteOpinion(String gameId, String topicId, String uid) async {
  await FirebaseFirestore.instance
      .collection(DefaultText.opinions)
      .doc(DefaultText.topics)
      .collection(gameId)
      .doc(topicId)
      .delete();
  await FirebaseFirestore.instance
      .collection(DefaultText.opinions)
      .doc(DefaultText.users)
      .collection(uid)
      .doc(topicId)
      .delete();
}

_deleteMyimages(
  String gameId,
  String topicId,
) {}

_deleteMyPublic(String uid, String topicId) async {
  await FirebaseFirestore.instance
      .collection(DefaultText.topics)
      .doc(DefaultText.users)
      .collection(uid)
      .doc(topicId)
      .delete();
}

_deleteTopic(
  String gameId,
  String topicId,
) async {
  await FirebaseFirestore.instance
      .collection(DefaultText.topics)
      .doc(DefaultText.topics)
      .collection(gameId)
      .doc(topicId)
      .delete();
}
