import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TopicDetailLogic extends GetxController {
  ///话题
  var entity = TopicModel().obs;
  String gameId = '';
  String topicId = '';
  String uid = '';
  String name = '';
  late Query<TopicModel> getTopic;

  ///获取话题详情
  late CollectionReference<TopicModel> topicRef;

  ///获取评价数
  late CollectionReference<OpinionModel> perspectiveNumber;

  ///获取评论详情
  late CollectionReference<CommentModel> topicCommentListRef;

  TextEditingController comment = TextEditingController();

  ///是否能发送消息
  var isSend = false.obs;
  @override
  void onInit() {
    entity.value = Get.arguments["entity"];
    gameId = entity.value.gameId ?? '';
    topicId = entity.value.topicId ?? '';
    uid = entity.value.uid ?? '';
    name = entity.value.name ?? '';

    getTopic = FirebaseFirestore.instance
        .collection(DefaultText.topics)
        .doc(DefaultText.topics)
        .collection(gameId)
        .withConverter<TopicModel>(
            fromFirestore: (snapshots, _) =>
                TopicModel.fromJson(snapshots.data()!),
            toFirestore: (tab, _) => tab.toJson())
        .where('topicId', isEqualTo: entity.value.topicId);

    topicCommentListRef = FirebaseFirestore.instance
        .collection(DefaultText.comment)
        .doc(DefaultText.topics)
        .collection(gameId)
        .doc(topicId)
        .collection(topicId)
        .withConverter<CommentModel>(
          fromFirestore: (snapshots, _) =>
              CommentModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        );
    super.onInit();
  }

  ///发送评论
  Future<void> sendComment() async {
    KeyboardBack.keyboardBack();
    var commentId = const Uuid().v4();
    String trimmedInput = comment.text.trim();
    comment.text = "";
    DateTime uploadTime = DateTime.now();
    String sendTime =
        '${uploadTime.year}-${uploadTime.month}-${uploadTime.day} ${uploadTime.hour}:${uploadTime.minute}';
    Map<String, dynamic> param = {
      'gameId': gameId,
      'topicId': topicId,
      'uid': uid,
      'name': ApiService.instance.getName(),
      'commentId': commentId,
      'content': trimmedInput,
      'time': sendTime,
      'preciseTime': uploadTime.millisecondsSinceEpoch
    };
    if (await _topicIsExist()) {
      await FirebaseFirestore.instance
          .collection(DefaultText.comment)
          .doc(DefaultText.topics)
          .collection(gameId)
          .doc(topicId)
          .collection(topicId)
          .doc(commentId)
          .set(param);
      if (await _topicIsExist()) {
        await myComment(commentId, trimmedInput, sendTime, name);
        if (await _topicIsExist()) {
          await _updateNumber('comment', 1);
        } else {
          await _deleteMyComment(commentId);
          await _deleteTopicComment(commentId);
        }
      } else {
        await _deleteTopicComment(commentId);
      }
      comment.text = "";
      isSend.value = false;
    }
  }

  ///记录我的评论
  Future<void> myComment(
      String commentId, String content, String time, String name) async {
    Map<String, dynamic> param = {};
    param['gameId'] = gameId;
    param['topicId'] = topicId;
    param['commentId'] = commentId;
    param['content'] = content;
    param['uid'] = uid;
    param['time'] = time;
    param['name'] = name;
    param['preciseTime'] = DateTime.now().millisecondsSinceEpoch;

    await FirebaseFirestore.instance
        .collection(DefaultText.comment)
        .doc(DefaultText.users)
        .collection(uid)
        .doc(commentId)
        .set(param);
  }

  ///刷新数量
  Future<void> _updateNumber(String param, int number) async {
    final topicRef = FirebaseFirestore.instance
        .collection(DefaultText.topics)
        .doc(DefaultText.topics)
        .collection(gameId)
        .doc(topicId);
    await FirebaseFirestore.instance.runTransaction((transaction) {
      return transaction.get(topicRef).then((sfDoc) {
        final newNumber = sfDoc.get(param) + number;
        transaction.update(topicRef, {param: newNumber});
        return newNumber;
      });
    });
  }

  Future<int> getCollectionLength() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DefaultText.comment)
        .doc(DefaultText.topics)
        .collection(gameId)
        .doc(topicId)
        .collection(topicId)
        .get();
    return querySnapshot.docs.length;
  }

  ///删除话题里的评论
  Future<void> _deleteTopicComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection(DefaultText.comment)
        .doc(DefaultText.games)
        .collection(gameId)
        .doc(topicId)
        .collection(topicId)
        .doc(commentId)
        .delete();
  }

  ///删除我的评论
  Future<void> _deleteMyComment(String commentId) async {
    await FirebaseFirestore.instance
        .collection(DefaultText.comment)
        .doc(DefaultText.users)
        .collection(uid)
        .doc(gameId)
        .collection(topicId)
        .doc(commentId)
        .delete();
  }

  ///TextFiled change
  void changeText(String text) {
    String newText = text.trim();
    isSend.value = (newText.isNotEmpty);
  }

  ///判断话题文档是否存在
  Future<bool> _topicIsExist() async {
    return await ApiService.instance.topicIsExist(gameId, topicId);
  }
}
