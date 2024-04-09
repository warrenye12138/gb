import 'package:flutter/material.dart';

class MyLoading {
  MyLoading._();

  static final MyLoading _instance = MyLoading._();
  static MyLoading get instance => _instance;

  late final GlobalKey<State> _loadingKey = GlobalKey<State>();

  void showLoading() {
    showDialog(
      context: _loadingKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _LoadingWidget(),
        );
      },
    );
  }

  void dismiss() {
    Navigator.of(_loadingKey.currentContext!).pop();
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ModalBarrier(
          color: Colors.black.withOpacity(0.3),
          dismissible: false,
        ),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
