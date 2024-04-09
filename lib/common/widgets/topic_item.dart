import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/res/res.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/third_party/toast.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/common/widgets/custom_widget.dart';
import 'package:gb/common/widgets/dialog_action_sheet.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/photo.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class TopicItemWidget extends StatefulWidget {
  final TopicModel entity;
  final bool isDetail;
  bool? isList;
  bool? needPlay = false;

  TopicItemWidget({
    super.key,
    required this.entity,
    this.isDetail = false,
    this.isList,
    this.needPlay,
  });

  @override
  State<StatefulWidget> createState() => _TopicItemWidgetState();
}

class _TopicItemWidgetState extends State<TopicItemWidget> {
  PageController? pageController;

  // int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getItem();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  Widget _getItem() {
    return GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.pathToTopicDetail,
              arguments: {'entity': widget.entity});
        },
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: widget.isDetail
                        ? const EdgeInsets.symmetric(horizontal: 15)
                        : null,
                    child: _headerWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  Container(
                    padding: widget.isDetail
                        ? const EdgeInsets.symmetric(horizontal: 15)
                        : null,
                    child: _getContent(widget.entity.content ?? ""),
                  ),
                  _getImages(widget.entity.images),
                  widget.isDetail
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                  _footerWidget(),
                ],
              ),
            ),
            Container(
              color: widget.isDetail ? Colors.transparent : Colors.grey[500],
              height: 0.4,
            ),
          ],
        ));
  }

  ///头部
  _headerWidget() {
    return Padding(
      padding: widget.isDetail
          ? const EdgeInsets.symmetric(vertical: 5)
          : const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: WidgetFirestore<UserEntity>(
          query: FirebaseFirestore.instance
              .collection(DefaultText.users)
              .withConverter<UserEntity>(
                fromFirestore: (snapshots, _) {
                  return UserEntity.fromJson(snapshots.data()!);
                },
                toFirestore: (tab, _) => tab.toJson(),
              )
              .where('uid', isEqualTo: widget.entity.uid),
          widgetBuilder: (context, doc) {
            return Row(
              children: [
                CustomCacheImage(
                  boxBorder: Border.all(
                    width: 1,
                    color: AppColors.colorWhite,
                  ),
                  imageUrl: doc!.data().avatar ?? '',
                  width: 35,
                  height: 35,
                  isHeader: true,
                  isCircle: true,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SimpleText(
                        textAlign: TextAlign.start,
                        text: doc.data().name?.toUpperCase() ?? "",
                        fontSize: 13,
                        fontName: FFontFamily.fontBold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _getTime(
                        widget.entity.time,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                if (widget.entity.uid == ApiService.instance.getUid() &&
                    widget.entity.type != 'first-text')
                  InkWell(
                    child: const Icon(
                      Icons.more_vert_outlined,
                      size: 25,
                      color: AppColors.greyColor,
                    ),
                    onTap: () {
                      showActionSheet(
                        actions: [
                          ActionSheetItem(
                            action: () async {
                              if (widget.isDetail) {
                                await ApiService.instance
                                    .deleteTopic(widget.entity);
                              } else {
                                await ApiService.instance
                                    .deleteTopic(widget.entity);
                              }
                            },
                            title: "DELETE",
                          )
                        ],
                      );
                    },
                  ),
              ],
            );
          }),
    );
  }

  ///文本内容
  _getContent(String content) {
    return Padding(
      padding: widget.isDetail
          ? const EdgeInsets.symmetric(vertical: 5)
          : const EdgeInsets.only(left: 15, right: 15),
      child: SimpleText(
        textAlign: TextAlign.start,
        text: content,
        lineNumber: widget.isDetail ? 0 : 4,
        fontSize: 15,
        height: 1.4,
      ),
    );
  }

  ///图片内容
  _getImages(
    List<String>? images,
  ) {
    if (images == null || images.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: images.length == 1
          ? InkWell(
              onTap: () {
                ShowBigPhotosWidget.showImages(context,
                    images: images, currentIndex: 0);
              },
              child: CustomCacheImage(
                radius: 8,
                imageUrl: images.first,
                fit: BoxFit.cover,
              ),
            )
          : images.length == 2 || images.length == 4
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: images.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        ShowBigPhotosWidget.showImages(context,
                            images: images, currentIndex: index);
                      },
                      child: CustomCacheImage(
                        radius: 8,
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                )
              : images.length == 3 || images.length > 4
                  ? GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              ShowBigPhotosWidget.showImages(context,
                                  images: images, currentIndex: index);
                            },
                            child: CustomCacheImage(
                              radius: 8,
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                            ),
                          ))
                  : const SizedBox.shrink(),
    );
  }

  ///底部评价及评论
  _footerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {},
        child: Container(
          color: Colors.transparent,
          margin: const EdgeInsets.only(bottom: 10),
          child: StreamBuilder<DocumentSnapshot<OpinionModel>>(
            stream: FirebaseFirestore.instance
                .collection(DefaultText.opinions)
                .doc(DefaultText.users)
                .collection(widget.entity.uid!)
                .doc(widget.entity.topicId)
                .withConverter<OpinionModel>(
                    fromFirestore: (snapshots, _) =>
                        OpinionModel.fromJson(snapshots.data()!),
                    toFirestore: (tab, _) => tab.toJson())
                .snapshots(),
            builder: (context, snapshot) {
              return widget.isDetail
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.7,
                            ),
                          ),
                          child: Row(
                            children: [
                              _getPerspective(
                                Icons.sentiment_satisfied,
                                1,
                                number: widget.entity.good ?? 0,
                                isSelect: snapshot.data?.data()?.state == 1,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height: 20,
                                width: 1,
                                decoration:
                                    const BoxDecoration(color: Colors.black38),
                              ),
                              _getPerspective(
                                Icons.sentiment_neutral,
                                2,
                                number: widget.entity.middle ?? 0,
                                isSelect: snapshot.data?.data()?.state == 2,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height: 20,
                                width: 1,
                                decoration:
                                    const BoxDecoration(color: Colors.black38),
                              ),
                              _getPerspective(
                                Icons.sentiment_dissatisfied,
                                3,
                                number: widget.entity.bad ?? 0,
                                isSelect: snapshot.data?.data()?.state == 3,
                              ),
                            ],
                          ),
                        ),
                        if (!widget.isDetail) _getComments(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  ///时间
  _getTime(String? time) {
    if (time == null) return const Text("");
    return SimpleText(
      text: time,
      fontSize: 11,
      textColor: AppColors.greyColor,
      fontName: FFontFamily.fontLight,
    );
  }

  ///评论
  _getComments() {
    return InkWell(
      onTap: () async {
        Get.toNamed(AppRoutes.pathToTopicDetail,
            arguments: {'entity': widget.entity});
      },
      child: Row(
        children: [
          Icon(
            Icons.comment,
            color: Colors.grey.shade700,
            weight: 25,
          ),
          const SizedBox(
            width: 2,
          ),
          SimpleText(
            text: intChangeString(widget.entity.comment ?? 0),
            textAlign: TextAlign.left,
            fontSize: 16,
            textColor: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  ///好中差
  _getPerspective(
    IconData? icon,
    int state, {
    int number = 0,
    bool isSelect = false,
  }) {
    return InkWell(
      onTap: () {
        Loading.show();
        ApiService.instance.publicOpinion(
          gameId: widget.entity.gameId ?? "",
          topicId: widget.entity.topicId ?? "",
          state: isSelect ? 0 : state,
        );
        Loading.dismiss();
      },
      child: Container(
        margin: const EdgeInsets.all(6),
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
            ),
            SizedBox(
              width: 30,
              child: Center(
                child: SimpleText(
                  text: intChangeString(number),
                  textAlign: TextAlign.left,
                  fontSize: 14,
                  textColor: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String intChangeString(int number) {
  if (number < 0) {
    return "0";
  } else if (number < 999) {
    return number.toString();
  } else if (number > 1000 && number < 9999) {
    return "${(number / 10000).toStringAsFixed(1)}k";
  } else {
    return "${(number / 10000).toStringAsFixed(1)}w";
  }
}
