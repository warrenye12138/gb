import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/keep_alive_wrapper.dart';
import 'package:gb/common/widgets/my_comments.dart';
import 'package:gb/pages/my_comment/my_comment_logic.dart';
import 'package:get/get.dart';

class MyCommentPage extends StatefulWidget {
  const MyCommentPage({super.key});

  @override
  State<MyCommentPage> createState() => _MyCommentPageState();
}

class _MyCommentPageState extends State<MyCommentPage> {
  final logic = Get.put(MyCommentLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的评论'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: ListFirestoreListView<TopicCommentModel>(
        query: logic.commentListRef,
        itemBuilder: (context, snapshot, index) {
          return _getItem(snapshot.data()) ?? const SizedBox.shrink();
        },
        errorBuilder: (context, object, trace) {
          return const Text('获取数据错误');
        },
        emptyBuilder: (context) {
          return const Text('你没有发布过评论！');
        },
      ),
    );
  }

  _getItem(TopicCommentModel comment) {
    return StreamBuilder<DocumentSnapshot<TopicModel>>(
      stream: FirebaseFirestore.instance
          .collection(DefaultText.topics)
          .doc(DefaultText.topics)
          .collection(comment.gameId!)
          .doc(comment.topicId!)
          .withConverter<TopicModel>(
            fromFirestore: (snapshots, _) =>
                TopicModel.fromJson(snapshots.data()!),
            toFirestore: (tab, _) => tab.toJson(),
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          var data = snapshot.data!.data();
          return KeepAliveWrapper(
            child: MyComments(
              entity: data!,
              commentModel: comment,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
