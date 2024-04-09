import 'package:flutter/material.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/keep_alive_wrapper.dart';
import 'package:gb/common/widgets/topic_item.dart';
import 'package:gb/pages/my_post/my_post_logic.dart';
import 'package:get/get.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {

  final logic = Get.put(MyPostLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我发布的话题'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon:const Icon(Icons.arrow_back_ios)),
      ),
      body: ListFirestoreListView<TopicModel>(
        query: logic.topicListRef,
        itemBuilder: (context, snapshot, index) {
          return KeepAliveWrapper(
              child: TopicItemWidget(
            entity: snapshot.data(),
            needPlay: false,
          ));
        },
        emptyBuilder: (context) {
          return Text("没有发布过");
        },
        errorBuilder: (context, error, other) {
          return Text('数据错误');
        },
      )
    );
  }
}
