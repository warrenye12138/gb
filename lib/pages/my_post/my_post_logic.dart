import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';

class MyPostLogic extends GetxController {
  UserEntity user = ApiService.instance.userInfo ?? UserEntity();
  late Query<TopicModel> topicListRef;

  @override
  void onInit() {
    topicListRef = FirebaseFirestore.instance
        .collection(DefaultText.topics)
        .doc(DefaultText.users)
        .collection(user.uid!)
        .withConverter<TopicModel>(
          fromFirestore: (snapshots, _) =>
              TopicModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        )
        .orderBy('time', descending: true)
        .limit(10);
    super.onInit();
  }
}
