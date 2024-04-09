import 'package:flutter/material.dart';
import 'package:gb/pages/splash/splash_logic.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashLogic logic = Get.put(SplashLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [Positioned(
          top: 50,
          right: 40,
          child: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon:const Icon(
              Icons.close,
              size: 40,
            ),
            onPressed: () {
              logic.get();
            },
          ),
        ),]
      ),
    );
  }
}
