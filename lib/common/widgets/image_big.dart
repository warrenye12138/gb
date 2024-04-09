import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gb/common/third_party/su.dart';
import 'package:get/get.dart';

class ImageBigShow {
  static  showImages(List<File> list, {int index = 0}) {
    Get.dialog(
      Stack(
        children: <Widget>[
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                color: Colors.black,
                width: Su.sw,
                height: Su.sh,
                child: Center(child: Image.file(list[i])),
              );
            },
            controller: PageController(initialPage: index),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: InkWell(
              onTap: () => Get.back(),
              child: ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black.withOpacity(0.5),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
