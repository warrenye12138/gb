import 'package:flutter/material.dart';
 import 'package:gb/common/values/fonts/fonts.dart';
import 'package:gb/common/values/fonts/fonts_name.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/pages/edit_profile/edit_profile.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final logic = Get.put(EditProfileLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("编辑头像"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back)),
        ),
        body: Obx(() {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              //头像
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                      child: Center(
                          child: Text(
                        '编辑头像:',
                        style: TextStyle(fontSize: 20),
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        logic.selectAvatar();
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: logic.avatar.value != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: Image.file(
                                  logic.avatar.value!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CustomCacheImage(
                                isCircle: true,
                                height: 100,
                                width: 100,
                                imageUrl: logic.user.avatar ?? '',
                                isHeader: true,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              //名字
              Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          '编辑名字:',
                          style:
                              TextStyle(fontSize: 20, color: Colors.blue[300]),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        logic.user.name!,
                        style: Fonts().getfonts(FontsName.zCOOLKuaiLe, 30,
                            color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: logic.userName,
                        decoration: const InputDecoration(
                          label: Text('新名字:'),
                          labelStyle: TextStyle(fontSize: 20),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    logic.uploadInfo();
                  },
                  child: const Text(
                    '上传',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        }));
  }
}
