import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gb/common/model/game_model.dart';
import 'package:gb/common/res/gaps.dart';
import 'package:gb/common/widgets/custom_cache_image.dart';
import 'package:gb/common/widgets/custom_widget.dart';
import 'package:gb/common/widgets/firestore_list_view.dart';
import 'package:gb/common/widgets/sliver.dart';
import 'package:gb/pages/home/home_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageLogic logic = Get.put(HomePageLogic());

  @override
  void initState() {
    logic.controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: empty,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            '游戏',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  logic.toUploadGameView();
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.blue[300],
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverHeaderDelegate(
                      maxHeight: 40,
                      minHeight: 40,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (value) {
                                logic.inputText.value = logic.controller.text;
                              },
                              controller: logic.controller,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                fillColor: Colors.grey[100],
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none),
                                hintText: '搜索游戏',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                ),
                                prefixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.blue[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: gamesList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gamesList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () {
          return logic.listGrid.value
              ? FirestoreListView<GameModel>(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  query: logic.inputText.value.isEmpty
                      ? logic.gamesListRef
                      : logic.gamesListRef
                          .where('gameName', isEqualTo: logic.inputText.value),
                  itemBuilder: (context, snapshot) {
                    GameModel debate = snapshot.data();
                    return GameItem(
                      chosenGame: debate,
                      onTap: () => {
                        logic.chosenTo(debate),
                        logic.saveLastPAge(),
                      },
                      listOrGrid: logic.listGrid.value,
                    );
                  },
                  emptyBuilder: (context) {
                    return const Center(child: Text("没有游戏!"));
                  },
                )
              : GridFirestoreListView<GameModel>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  query: logic.inputText.value.isEmpty
                      ? logic.gamesListRef
                      : logic.gamesListRef
                          .where('gameName', isEqualTo: logic.inputText.value),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, snapshot, index) {
                    GameModel debate = snapshot.data();
                    return GameItem(
                      chosenGame: debate,
                      onTap: () {
                        logic.chosenTo(debate);
                        logic.saveLastPAge();
                      },
                      listOrGrid: logic.listGrid.value,
                    );
                  },
                  emptyBuilder: (context) {
                    return const Center(child: Text("没有游戏!"));
                  },
                );
        },
      ),
    );
  }
}

class GameItem extends StatelessWidget {
  final GameModel chosenGame;
  final void Function()? onTap;
  final bool listOrGrid;

  const GameItem(
      {super.key,
      required this.chosenGame,
      this.onTap,
      required this.listOrGrid});

  @override
  Widget build(BuildContext context) {
    return listOrGrid
        ? GestureDetector(
            onTap: onTap,
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(width: 0.3, color: Colors.grey),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SimpleText(
                    text: chosenGame.gameName ?? '',
                    textColor: Colors.black,
                    fontSize: 17,
                    lineNumber: 1,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      child: chosenGame.gameIcon != null
                          ? SizedBox(
                              width: 50,
                              height: 80,
                              child: CustomCacheImage(
                                imageUrl: chosenGame.gameIcon,
                              ),
                            )
                          : empty),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: chosenGame.gameIcon != null
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: CustomCacheImage(
                                imageUrl: chosenGame.gameIcon,
                              ),
                            )
                          : empty),
                  const SizedBox(
                    height: 15,
                  ),
                  SimpleText(
                    text: chosenGame.gameName ?? '',
                    textColor: Colors.black,
                    fontSize: 13,
                    lineNumber: 1,
                  ),
                ],
              ),
            ),
          );
  }
}
