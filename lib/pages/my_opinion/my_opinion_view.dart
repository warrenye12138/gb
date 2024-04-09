import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/res/colors.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/keep_alive_wrapper.dart';
import 'package:gb/common/widgets/topic_item.dart';
import 'package:gb/pages/my_opinion/my_opinion_logic.dart';
import 'package:get/get.dart';

class MyOpinionPage extends StatefulWidget {
  const MyOpinionPage({super.key});

  @override
  State<MyOpinionPage> createState() => _MyOpinionPageState();
}

class _MyOpinionPageState extends State<MyOpinionPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(MyOpinionLogic());

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: logic.tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我评价的话题'),
        centerTitle: true,
        leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        bottom: TabBar(
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 16),
          isScrollable: false,
          controller: _tabController,
          labelColor: Colors.blue,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.themeSubColor,
          tabs: logic.tabs
              .map((e) => Tab(
                    text: e,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          Center(
            child: ListFirestoreListView<OpinionModel>(
              query: logic.goodList,
              itemBuilder: (context, snapshot, index) {
                return getItem(snapshot.data()) ?? const SizedBox();
              },
              emptyBuilder: (context) {
                return const Center(
                  child: Text("没有好评过的话题"),
                );
              },
              errorBuilder: (context, error, other) {
                return const Center(
                  child: Text('显示错误'),
                );
              },
            ),
          ),
          Center(
            child: ListFirestoreListView<OpinionModel>(
              query: logic.middleList,
              itemBuilder: (context, snapshot, index) {
                return getItem(snapshot.data()) ?? const SizedBox();
              },
              emptyBuilder: (context) {
                return const Center(
                  child: Text("没有无感的话题"),
                );
              },
              errorBuilder: (context, error, other) {
                return const Center(
                  child: Text('显示错误'),
                );
              },
            ),
          ),
          Center(
            child: ListFirestoreListView<OpinionModel>(
              query: logic.badList,
              itemBuilder: (context, snapshot, index) {
                return getItem(snapshot.data()) ?? const SizedBox();
              },
              emptyBuilder: (context) {
                return const Center(
                  child: Text("没有差评的话题"),
                );
              },
              errorBuilder: (context, error, other) {
                return const Center(
                  child: Text('显示错误'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  getItem(OpinionModel opinion) {
    return StreamBuilder<DocumentSnapshot<TopicModel>>(
        stream: FirebaseFirestore.instance
            .collection(DefaultText.topics)
            .doc(DefaultText.topics)
            .collection(opinion.gameId!)
            .doc(opinion.topicId!)
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
              child: TopicItemWidget(
                entity: data!,
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
