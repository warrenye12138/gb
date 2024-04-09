import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb/common/routes/app_pages.dart';
import 'package:gb/common/services/api_services.dart';
import 'package:gb/common/third_party/firebase_db.dart';
import 'package:gb/common/third_party/firebase_storage.dart';
import 'package:gb/common/third_party/su.dart';
import 'package:gb/common/third_party/toast.dart';
import 'package:gb/common/utils/keyboard.dart';
import 'package:gb/firebase_options.dart';
import 'package:gb/pages/home/home_page_view.dart';
import 'package:gb/pages/me/me.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(ApiService());
  FirebaseDbManage.getInstance();
  FirebaseStorageManage.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.getPages,
      initialRoute: AppPages.initial,
      home: const MyHomePage(),
      builder: (context, child) {
        Su.init(context);
        child = MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            body: GestureDetector(
              onTap: KeyboardBack.keyboardBack,
              child: child!,
            ),
          ),
        );
        child = Loading.init()(context, child);
        return child;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const MePage(),
  ];
  PageController? controller;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ApiService.instance.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: PageView.builder(
            itemCount: pages.length,
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) => pages[_currentIndex])),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '主页',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '个人`'),
          ],
          onTap: _ontapped,
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Colors.blue[300],
          selectedFontSize: 15,
          unselectedItemColor: Colors.grey[500],
          unselectedFontSize: 15,
        ),
      ),
    );
  }

  _ontapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
