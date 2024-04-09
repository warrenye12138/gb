import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gb/common/values/texts/texts.dart';

class FirebaseDbManage {
  FirebaseDbManage._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // static FirebaseDbManage? _instance;

  ///发表话题
  static Future<void> publicTopic(
    String gameId,
    String topicId,
    Map<String, dynamic> param,
  ) async {
    try {
      await db
          .collection(DefaultText.topics)
          .doc(DefaultText.topics)
          .collection(gameId)
          .doc(topicId)
          .set(param);
    } catch (e) {}
  }

  ///记录自己的话题
  static Future<void> publicMyTopic(
    String uid,
    String topicId,
    Map<String, dynamic> param,
  ) async {
    try {
      await db
          .collection(DefaultText.topics)
          .doc(DefaultText.users)
          .collection(uid)
          .doc(topicId)
          .set(param);
    } catch (e) {}
  }

  //初始评价
  static Future<void> initOpinions(
    String uid,
    String topicId,
  ) async {
    Map<String, dynamic> param = {
      'uid': uid,
      'topicId': topicId,
      'time': DateTime.now().millisecondsSinceEpoch,
      'state': 0,
    };
    try {
      await db
          .collection(DefaultText.opinions)
          .doc(DefaultText.users)
          .collection(uid)
          .doc(topicId)
          .set(param);
    } catch (e) {}
  }

  static void getInstance() {}
}
