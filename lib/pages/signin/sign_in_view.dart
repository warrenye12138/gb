import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb/pages/signin/sign_in_logic.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  SignInLogic logic = Get.put(SignInLogic());

  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            automaticallyImplyLeading: false,
            title: const Text(
              '注册',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //邮箱
                    Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            labelText: '输入邮箱',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            helperText: '邮箱格式: xxxx@xxxx.xxx',
                            helperStyle: TextStyle(color: Colors.grey[500]),
                            suffixIcon: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                logic.textClear(logic.emailController);
                              },
                              child: const Icon(Icons.close),
                            ),
                          ),
                          style: const TextStyle(fontSize: 20),
                          controller: logic.emailController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    //密码
                    Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            labelText: '输入密码',
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.blue,
                            ),
                            helperText: '至少输入六位',
                            helperStyle: TextStyle(color: Colors.grey[500]),
                            suffixIcon: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                logic.textClear(logic.passwordController);
                              },
                              child: const Icon(Icons.close),
                            ),
                          ),
                          obscureText: true,
                          style: const TextStyle(fontSize: 20),
                          controller: logic.passwordController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    //确认密码
                    Column(
                      children: [
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.blue,
                            ),
                            labelText: '再次输入密码',
                            helperText: '至少输入六位',
                            helperStyle: TextStyle(color: Colors.grey[500]),
                            suffixIcon: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                logic.textClear(logic.passwordController);
                              },
                              child: const Icon(Icons.close),
                            ),
                          ),
                          style: const TextStyle(fontSize: 20),
                          controller: logic.makeSureController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    //注册
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        logic.signin();
                      },
                      child: const Text(
                        '注册',
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
