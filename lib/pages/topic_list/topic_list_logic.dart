import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';

class TopicListLogic extends GetxController {
  var gameId = '';
  var name = "".obs;
  var gameIcon = ''.obs;
  late CollectionReference<TopicModel> topicListRef;
  @override
  void onInit() {
    name.value = Get.arguments['name'];
    gameIcon.value = Get.arguments['gameIcon'] ?? '';
    gameId = Get.arguments['gameId'];

    topicListRef = FirebaseFirestore.instance
        .collection(DefaultText.topics)
        .doc(DefaultText.topics)
        .collection(gameId)
        .withConverter<TopicModel>(
          fromFirestore: (snapshots, _) =>
              TopicModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        );
    super.onInit();
  }

  //跳转到games页面
  void toGamesPage() async {
    Get.toNamed(AppRoutes.pathToHome);
  }

  //跳转到上传话题页面
  void toUploadTopicPage() async {
    Get.toNamed(AppRoutes.pathToUploadTopic, arguments: {'gameId': gameId});
  }

  void toTopicDetailPage(){}
}
