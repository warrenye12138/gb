import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/res/gaps.dart';
import 'package:gb/common/values/fonts/fonts.dart';
import 'package:gb/common/values/fonts/fonts_name.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/pages/me/me.dart';
import 'package:get/get.dart';
import 'package:random_name_generator/random_name_generator.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> with SingleTickerProviderStateMixin {
  var randomNames = RandomNames(Zone.china);

  MeLogic logic = Get.put(MeLogic());

  late TabController controller = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: empty,
        surfaceTintColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '个人',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onDoubleTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(
                Icons.logout,
                color: Colors.blue[300],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    logic.toEditProfile();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: CustomCacheImage(
                          isCircle: true,
                          height: 100,
                          width: 100,
                          imageUrl: logic.user.avatar ?? '',
                          isHeader: true,
                        ),
                      ),
                      Text(
                        logic.name.value,
                        style: Fonts().getfonts(FontsName.zCOOLKuaiLe, 30,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: logic.functions.length,
                itemBuilder: (context, index) => function(
                      logic.functions[index].name,
                      logic.functions[index].icon,
                      logic.functions[index].route,
                    )),
          ],
        ),
      ),
    );
  }

  function(
    String name,
    IconData icon,
    String route,
  ) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        logic.toNextPage(route);
      },
      child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.black),
            ),
          ),
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.grey[500],
                      size: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
                IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      logic.toNextPage(route);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ))
              ],
            ),
          )),
    );
  }
}
