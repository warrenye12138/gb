import 'package:flutter/material.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/keep_alive_wrapper.dart';
import 'package:gb/common/widgets/topic_item.dart';
import 'package:gb/pages/topic_list/topic_list.dart';
import 'package:get/get.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({super.key});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  final logic = Get.put(TopicListLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: InkWell(
            onTap: () => logic.toGamesPage(),
            child: CustomCacheImage(
              imageUrl: logic.gameIcon.value,
              isCircle: true,
            ),
          ),
        ),
        title: Text(logic.name.value),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () {
                  logic.toUploadTopicPage();
                },
                icon: const Icon(Icons.add)),
          )
        ],
      ),
      body: ListFirestoreListView<TopicModel>(
        query: logic.topicListRef.orderBy("time", descending: true).limit(10),
        itemBuilder: (context, snapshot, index) {
          return KeepAliveWrapper(
            child: TopicItemWidget(
              entity: snapshot.data(),
            ),
          );
        },
        emptyBuilder: (context) {
          return const Center(
            child: Text("没有已发布的话题"),
          );
        },
        errorBuilder: (context, error, other) {
          return const Center(
            child: Text('显示错误'),
          );
        },
      ),
    );
  }
}
