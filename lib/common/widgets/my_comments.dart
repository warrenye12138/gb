import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 import 'package:gb/common/model/topic_comment.dart';
import 'package:gb/common/model/topic_model.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/res/colors.dart';
import 'package:gb/common/res/fonts.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/values/texts/texts.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/common/widgets/custom_widget.dart';
 
import 'package:get/get.dart';

class MyComments extends StatefulWidget {
  final TopicModel entity;
  final TopicCommentModel commentModel;

  const MyComments({
    super.key,
    required this.entity,
    required this.commentModel,
  });

  @override
  State<MyComments> createState() => _MyCommentsState();
}

class _MyCommentsState extends State<MyComments> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.pathToTopicDetail,
            arguments: {'entity': widget.entity});
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerWidget(),
                const SizedBox(
                  height: 10,
                ),
                SimpleText(
                  textAlign: TextAlign.start,
                  text: widget.commentModel.content ?? "",
                  lineNumber: 1,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _getImages(widget.entity.images),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: SimpleText(
                            textAlign: TextAlign.start,
                            text:
                                "${widget.entity.name}: ${widget.entity.content}",
                            lineNumber: 2,
                            height: 1.8,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              color: Colors.grey[300],
              height: .5,
            ),
          ),
        ],
      ),
    );
  }

  _headerWidget() {
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder<DocumentSnapshot<UserEntity>>(
        stream: FirebaseFirestore.instance
            .collection(DefaultText.users)
            .doc(ApiService.instance.getUid())
            .withConverter<UserEntity>(
              fromFirestore: (snapshots, _) {
                return UserEntity.fromJson(snapshots.data()!);
              },
              toFirestore: (tab, _) => tab.toJson(),
            )
            .get()
            .asStream(),
        builder: (context, snapshot) {
          return Row(
            children: [
              CustomCacheImage(
                boxBorder: Border.all(
                  width: 1,
                  color: AppColors.colorWhite,
                ),
                imageUrl: snapshot.data?.data()?.avatar ?? '',
                width: 48,
                height: 48,
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
                      text: widget.commentModel.name ?? "",
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    _getTime(
                      widget.commentModel.time,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          );
        },
      ),
    );
  }

  _getTime(String? time) {
    if (time == null) return const Text("");
    return SimpleText(
      text: time,
      fontSize: 11,
      textColor: AppColors.greyColor,
      fontName: FFontFamily.fontLight,
    );
  }

  _getImages(List<String>? images) {
    if (images == null || images.isEmpty) return const SizedBox.shrink();
    return Container(
      child: images.isNotEmpty
          ? CustomCacheImage(
              radius: 8,
              imageUrl: images.first,
              width: 75,
              height: 75,
              fit: BoxFit.cover,
            )
          : null,
    );
  }
}
