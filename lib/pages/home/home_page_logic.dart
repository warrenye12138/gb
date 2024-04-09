import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:gb/common/model/game_model.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/common/values/texts/texts.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomePageLogic extends GetxController {
  TextEditingController controller = TextEditingController();
  late CollectionReference<GameModel> gamesListRef;
 
  var inputText = ''.obs;
  GameModel lastGameModel = GameModel();
  GameModel getlastGameModel = GameModel();
  bool status = false;
  bool listOrGrid = false;
  var listGrid = false.obs;
 
  @override
  void onInit() {
    gamesListRef =
        FirebaseFirestore.instance.collection(DefaultText.games).withConverter<GameModel>(
              fromFirestore: (snapshots, _) =>
                  GameModel.fromJson(snapshots.data()!),
              toFirestore: (article, _) => article.toJson(),
            );
    super.onInit();
  }

  @override
  void onReady() async {
    gamesListRef =
        FirebaseFirestore.instance.collection(DefaultText.games).withConverter<GameModel>(
              fromFirestore: (snapshots, _) =>
                  GameModel.fromJson(snapshots.data()!),
              toFirestore: (article, _) => article.toJson(),
            );
    listOrGrid = await isListOrGrid();
    listGrid.value = listOrGrid;
    super.onReady();
  }

  //根据Id跳转指定页面
  void chosenTo(GameModel model) {
    KeyboardBack.keyboardBack();

    Get.offAllNamed(AppRoutes.pathToTopicList, arguments: {
      'gameId': model.gameId,
      'name': model.gameName,
      'gameIcon': model.gameIcon,
    });
    lastGameModel.gameId = model.gameId!;
    lastGameModel.gameName = model.gameName!;
    lastGameModel.gameIcon = model.gameIcon??'';
  }

  void toUploadGameView() {
    Get.toNamed(AppRoutes.pathToUpload);
  }

  //保存上一次进入的game
  Future<void> saveLastPAge() async {
     final aaa = lastGameModel.toJson();
     final directory = await getApplicationDocumentsDirectory();
    final lastPageFile = File('${directory.path}/last_page.json');
    final lastPage = jsonEncode(aaa);
    await lastPageFile.writeAsString(lastPage);
  }

  //获取上一次进入的game
  Future<GameModel> getLastPage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/last_page.json');
    if (file.existsSync()) {
      final jsonString = await file.readAsString();
      Map<String, dynamic> loadedJson = jsonDecode(jsonString);
      getlastGameModel = GameModel.fromJson(loadedJson);
    }
    return getlastGameModel;
  }

  //根据是否存在保存的gameId判断是否有上一次进入的game
  Future<bool> isListOrGrid() async {
     GameModel pageIsExits = await getLastPage();
    if (pageIsExits.gameId != null) {
      status = true;
    }
    KeyboardBack.keyboardBack();
    return status;
  }
}
