import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:get/get.dart';

class MyOpinionLogic extends GetxController {
  UserEntity user = ApiService.instance.userInfo ?? UserEntity();
  final List<String> tabs = [
    '好评',
    '无感',
    '差评',
  ];

  int defaultIndex = 1;
  late Query<OpinionModel> goodList;
  late Query<OpinionModel> middleList;
   late Query<OpinionModel> badList;

  @override
  void onInit() async {
    goodList = FirebaseFirestore.instance
        .collection(DefaultText.opinions)
        .doc(DefaultText.users)
        .collection(user.uid!)
        .withConverter<OpinionModel>(
          fromFirestore: (snapshots, _) =>
              OpinionModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        )
        .where('state', isEqualTo: 1)
         .limit(10);
    middleList = FirebaseFirestore.instance
        .collection(DefaultText.opinions)
        .doc(DefaultText.users)
        .collection(user.uid!)
        .withConverter<OpinionModel>(
          fromFirestore: (snapshots, _) =>
              OpinionModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        )
        .where('state', isEqualTo:2)
         .limit(10);

    badList = FirebaseFirestore.instance
        .collection(DefaultText.opinions)
        .doc(DefaultText.users)
        .collection(user.uid!)
        .withConverter<OpinionModel>(
          fromFirestore: (snapshots, _) =>
              OpinionModel.fromJson(snapshots.data()!),
          toFirestore: (article, _) => article.toJson(),
        )
        .where('state', isEqualTo: 3)
         .limit(10);

    super.onInit();
  }

 
}
