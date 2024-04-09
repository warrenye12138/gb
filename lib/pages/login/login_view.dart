import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gb/pages/login/login_logic.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginLogic logic = Get.put(LoginLogic());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            '登录',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            _loginWidget(),
          ],
        ),
      ),
    );
  }

  _loginWidget() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Icon(
              Icons.people,
              size: 200,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: logic.emailController,
                decoration: InputDecoration(
                  labelText: '请输入邮箱',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  prefixText: '邮箱:  ',
                  prefixStyle: const TextStyle(color: Colors.blue),
                  border: const OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.black),
                      ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  suffixIcon: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      logic.textClear(logic.emailController);
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                obscureText: true,
                controller: logic.passwordController,
                decoration: InputDecoration(
                  labelText: '请输入密码',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  prefixText: '密码:  ',
                  prefixStyle: const TextStyle(color: Colors.blue),
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Colors.blue,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  suffixIcon: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      logic.textClear(logic.passwordController);
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.white,
                  onTap: () => logic.logIn(),
                  child: const Text(
                    "登录",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                InkWell(
                  splashColor: Colors.white,
                  onTap: () => logic.toSignInPage(),
                  child: const Text(
                    "注册",
                    style: TextStyle(color: Colors.blue, fontSize: 22),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
