import 'package:flutter/material.dart';
import 'package:gb/common/third_party/toast.dart';
import 'package:gb/pages/upload_game/upload_game_logic.dart';
import 'package:get/get.dart';

class UploadGamePage extends StatefulWidget {
  const UploadGamePage({super.key});

  @override
  State<UploadGamePage> createState() => _UploadGamePageState();
}

class _UploadGamePageState extends State<UploadGamePage> {
  UploadGameLogic logic = Get.put(UploadGameLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text('上传游戏'),
          centerTitle: true,
        ),
        body: Obx(() {
          return Center(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                //photo
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: logic.gameImageFile.value != null
                              ? Colors.transparent
                              : Colors.black,
                          width: 1)),
                  child: InkWell(
                    onTap: () {
                      logic.selectPhoto();
                    },
                    child: logic.gameImageFile.value != null
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            child: Image.file(
                              logic.gameImageFile.value!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        :const Icon(
                            Icons.upload,
                            size: 100,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                //name
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 70),
                  child: TextField(
                    controller: logic.nameController,
                    decoration: const InputDecoration(
                        hintText: '输入游戏名',
                        labelText: '    游戏名'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 70),
                  child: TextField(
                    controller: logic.descController,
                    decoration: const InputDecoration(
                        hintText: '游戏描述',
                        border: InputBorder.none),
                    maxLength: 100,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {Loading.show(isClick: false);
                    logic.uploadNewGame();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 140),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Center(
                        child: Text(
                          '上传',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                )
              ],
            ),
          );
        }));
  }
}
