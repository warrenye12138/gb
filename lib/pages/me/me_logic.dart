import 'package:flutter/material.dart';
import 'package:gb/common/model/function.dart';
import 'package:gb/common/model/user.dart';
import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:get/get.dart';

class MeLogic extends GetxController {
  var name = ''.obs;

  UserEntity user = ApiService.instance.userInfo ?? UserEntity();
  @override
  void onInit() async {
    name.value = user.name!;
    super.onInit();
  }

  List<MyFunction> functions = [
    MyFunction(
        name: '发布', icon: Icons.cloud_upload, route: AppRoutes.pathToMyPost),
    MyFunction(
        name: '评论', icon: Icons.cloud_circle, route: AppRoutes.pathToMyComment),
    MyFunction(
        name: '评价', icon: Icons.cloud_done, route: AppRoutes.pathToMyOpinion)
  ];

  void toNextPage(String nextPage) {
    Get.toNamed(nextPage);
  }

  void toEditProfile() {
    Get.toNamed(AppRoutes.pathToEditProfile);
  }
}
