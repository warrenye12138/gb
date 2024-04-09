import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/res/colors.dart';
import 'package:gb/common/res/fonts.dart';
import 'package:gb/common/res/gaps.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/common/widgets/custom_widget.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/sliver.dart';
import 'package:gb/common/widgets/topic_item.dart';
import 'package:gb/pages/topic_detail/topic_detail.dart';
import 'package:get/get.dart';

class TopicDetailPage extends StatefulWidget {
  const TopicDetailPage({super.key});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  late TopicDetailLogic logic = Get.put(TopicDetailLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('话题详情'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                  child: TopicItemWidget(
                    isDetail: true,
                    entity: logic.entity.value,
                    needPlay: false,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate(
                    minHeight: 50,
                    maxHeight: 50,
                    child: StreamBuilder<DocumentSnapshot<OpinionModel>>(
                      stream: FirebaseFirestore.instance
                          .collection(DefaultText.opinions)
                          .doc(DefaultText.users)
                          .collection(ApiService.instance.getUid())
                          .doc(logic.entity.value.topicId)
                          .withConverter<OpinionModel>(
                              fromFirestore: (snapshots, _) =>
                                  OpinionModel.fromJson(snapshots.data()!),
                              toFirestore: (tab, _) => tab.toJson())
                          .snapshots(),
                      builder: (context, snapshot) {
                        return WidgetFirestore<OpinionModel>(
                          query: FirebaseFirestore.instance
                              .collection(DefaultText.opinions)
                              .doc(DefaultText.users)
                              .collection(ApiService.instance.getUid())
                              .withConverter<OpinionModel>(
                                  fromFirestore: (snapshots, _) =>
                                      OpinionModel.fromJson(snapshots.data()!),
                                  toFirestore: (tab, _) => tab.toJson()),
                          widgetBuilder: (context, doc) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _getPerspective(
                                          Icons.sentiment_satisfied,
                                          1,
                                          perspective: 'good',
                                          isSelect:
                                              snapshot.data!.data()?.state == 1,
                                        ),
                                        WidgetFirestore<TopicModel>(
                                          query: logic.getTopic,
                                          widgetBuilder: (context, doc) {
                                            return Text(
                                                '${doc == null ? 0 : doc.data().good}');
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          height: 20,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black38),
                                        ),
                                        _getPerspective(
                                          Icons.sentiment_neutral,
                                          2,
                                          perspective: 'middle',
                                          isSelect:
                                              snapshot.data!.data()?.state == 2,
                                        ),
                                        WidgetFirestore<TopicModel>(
                                          query: logic.getTopic,
                                          widgetBuilder: (context, doc) {
                                            return Text(
                                                '${doc == null ? 0 : doc.data().middle}');
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          height: 20,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black38),
                                        ),
                                        _getPerspective(
                                          Icons.sentiment_dissatisfied,
                                          3,
                                          perspective: 'bad',
                                          isSelect:
                                              snapshot.data!.data()?.state == 3,
                                        ),
                                        WidgetFirestore<TopicModel>(
                                          query: logic.getTopic,
                                          widgetBuilder: (context, doc) {
                                            return Text(
                                                '${doc == null ? 0 : doc.data().bad}');
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox.shrink()
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: WidgetFirestore<TopicModel>(
                    query: logic.getTopic,
                    widgetBuilder: (BuildContext context,
                        QueryDocumentSnapshot<dynamic>? doc) {
                      if (doc == null) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Text('error'),
                        );
                      }
                      logic.entity.value = doc.data();
                      return Column(
                        children: [
                          Container(
                            color: AppColors.backColor.withOpacity(0.5),
                            height: 10,
                          ),
                          commentsNumber(logic.entity.value),
                          ListFirestoreListView<CommentModel>(
                            query: logic.topicCommentListRef
                                .orderBy('time')
                                .limit(10),
                            itemBuilder: (context, snapShot, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: _getItem(snapShot.data()),
                              );
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            reverse: true,
                            emptyBuilder: (context) {
                              return Container(
                                alignment: Alignment.center,
                                height: 240,
                                child:const Text(
                                  "没有评论" ,
                                  style:  TextStyle(
                                      fontSize: 16, fontWeight: FFont.bold),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: logic.comment,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "发表评论",
                          hintStyle: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w300),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1000)
                        ],
                        onChanged: (text) => logic.changeText(text),
                      ),
                    ),
                    Obx(() {
                      return InkWell(
                        onTap: logic.isSend.value ? logic.sendComment : null,
                        child: Container(
                          color: Colors.transparent,
                          margin: const EdgeInsets.only(left: 8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: SimpleText(
                              text: '发送',
                              fontSize: 16,
                              fontWeight: FFont.bold,
                              textColor: logic.isSend.value
                                  ? AppColors.themeColor
                                  : AppColors.greyColor,
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getPerspective(
    IconData icon,
    int state, {
    // int number = 0,
    String perspective = '',
    bool isSelect = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          ApiService.instance.publicOpinion(
            gameId: logic.entity.value.gameId ?? "",
            topicId: logic.entity.value.topicId ?? "",
            state: isSelect ? 0 : state,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: isSelect ? AppColors.themeColor : Colors.grey.shade700,
              ),
              const SizedBox(
                width: 2,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget commentsNumber(TopicModel model) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.transparent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SimpleText(
          textAlign: TextAlign.start,
          text: "评论数： ${model.comment}",
          fontSize: 16,
        ),
      ),
    );
  }

  _getItem(CommentModel entity) {
    return StreamBuilder<DocumentSnapshot<UserEntity>>(
      stream: FirebaseFirestore.instance
          .collection(DefaultText.users)
          .doc(entity.uid)
          .withConverter<UserEntity>(
            fromFirestore: (snapshots, _) =>
                UserEntity.fromJson(snapshots.data()!),
            toFirestore: (tab, _) => tab.toJson(),
          )
          .get()
          .asStream(),
      builder: (context, userSnapshot) {
        if (userSnapshot.data == null || userSnapshot.data!.data() == null) {
          return empty;
        }
        return _getContent(entity, userSnapshot.data!.data()!);
      },
    );
  }

  ///评论item
  _getContent(CommentModel entity, UserEntity user) {
    bool isSelf = user.uid == ApiService.instance.getUid();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 16),
              child: CustomCacheImage(
                imageUrl: user.avatar,
                isCircle: true,
                isHeader: true,
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SimpleText(
                          text: entity.name ?? "",
                          textColor: AppColors.greyColor,
                          fontSize: 12,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        getTime(entity.time),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelf
                          ? Colors.grey[300]
                          : AppColors.backColor.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: SimpleText(
                      textAlign: TextAlign.start,
                      text: entity.content ?? "",
                      fontSize: 16,
                      fontName: FFontFamily.fontLight,
                      height: 1.2,
                      textColor: AppColors.themeText,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 60,
            ),
          ],
        ),
      ],
    );
  }

  ///时间
  Widget getTime(String? time) {
    if (time == null) return const Text("");
    return SimpleText(
      text: time,
      fontSize: 11,
      textColor: AppColors.greyColor,
      fontName: FFontFamily.fontLight,
    );
  }
}
