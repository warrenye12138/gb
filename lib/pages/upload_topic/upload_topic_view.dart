import 'package:flutter/material.dart';
import 'package:gb/common/res/gaps.dart';
import 'package:gb/pages/upload_topic/upload_topic.dart';
import 'package:get/get.dart';

class UploadTopicPage extends StatelessWidget {
  UploadTopicPage({super.key});

  final logic = Get.put(UploadTopicLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上传话题博客'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              logic.goBack();
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          Obx(() {
            return logic.allowUpload.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        logic.allowUpload.value ? logic.postTopic() : null;
                      },
                      child: const Text(
                        '上传',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : empty;
          })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageWidget(),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Container(
                    height: 315,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      onChanged: (value) {
                        logic.allowUpload.value =
                            value.length > 10 ? true : false;
                      },
                      controller: logic.content,
                      maxLines: 10,
                      maxLength: 1000,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[300],
                          focusColor: Colors.grey[300],
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 36,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          logic.clickImagePick();
                        },
                        child: const Icon(Icons.add_a_photo_outlined),
                      ),
                    ),
                  ),
                  Obx(() {
                    return logic.allowUpload.value == false
                        ? Text(
                            '至少十个字符',
                            style: TextStyle(color: Colors.red[300]),
                          )
                        : empty;
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return Obx(
      () {
        if (logic.imageFiles.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return GridView.builder(
            padding:const EdgeInsets.symmetric(vertical: 5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logic.imageFiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => logic.clickImage(index),
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.file(
                        logic.imageFiles[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => logic.deleteImage(index),
                        child: Container(
                          color: Colors.black54, // 这个颜色可以根据你的需求更改
                          child: const Icon(
                            Icons.close, // 关闭图标
                            color: Colors.white, // 更改为白色
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
