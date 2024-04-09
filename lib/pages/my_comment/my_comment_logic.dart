import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';

class MyCommentLogic extends GetxController {
  late Query<TopicCommentModel> commentListRef;

  UserEntity user = ApiService.instance.userInfo ?? UserEntity();

  @override
  void onInit() {
    commentListRef = FirebaseFirestore.instance
        .collection(DefaultText.comment)
        .doc(DefaultText.users)
        .collection(user.uid!)
        .withConverter<TopicCommentModel>(
          fromFirestore: (snapshots, _) =>
              TopicCommentModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        )
        .orderBy("time", descending: true)
        .limit(10);
    super.onInit();
  }
}
