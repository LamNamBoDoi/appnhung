import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/auth_controller.dart';
import 'package:hethong/screen/home_screen.dart';
import 'package:hethong/widget/rep_textfiled.dart';
import 'package:line_icons/line_icons.dart';

import '../utils/app_constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            width: gWidth,
            height: gHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TopImage(),
                LoginText(),
                SizedBox(height: 20),
                EmailTextFiled(
                  textEditingController: emailController,
                ),
                const SizedBox(height: 20),
                PasswordTextFiled(
                  textEditingController: passwordController,
                ),
                const SizedBox(height: 25),
                LoginButton(
                  authController: authController,
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Login Button Components
class LoginButton extends StatelessWidget {
  LoginButton({
    Key? key,
    required this.authController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final AuthController authController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 900),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: gWidth,
        height: gHeight / 15,
        child: ElevatedButton(
          onPressed: () {
            // Kiểm tra trạng thái đang loading
            if (authController.isLoading.value) {
              return;
            }

            final email = emailController.text;
            final password = passwordController.text;

            // Gọi hàm login
            authController.login(email, password).then((_) {
              if (authController.message.value.startsWith("Chào mừng")) {
                // Hiển thị Snackbar khi đăng nhập thành công
                Get.snackbar(
                  "Đăng nhập thành công",
                  authController.message.value,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                Get.off(() => HomeScreen());
              } else {
                // Hiển thị Snackbar khi đăng nhập thất bại
                Get.snackbar(
                  "Đăng nhập thất bại",
                  authController.message.value,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              }
            });
          },
          child: Obx(() {
            return authController.isLoading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  );
          }),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: authController.isLoading.value
                ? Colors.grey
                : Colors.teal, // Màu chữ khi nút được nhấn
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}

// Password TextFiled Components
class PasswordTextFiled extends StatelessWidget {
  const PasswordTextFiled({Key? key, required this.textEditingController})
      : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 1800),
      child: RepTextFiled(
        icon: LineIcons.alternateUnlock,
        text: "Password",
        textEditingController: textEditingController,
        isPass: true,
      ),
    );
  }
}

// Email TextFiled Components
class EmailTextFiled extends StatelessWidget {
  const EmailTextFiled({Key? key, required this.textEditingController})
      : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 2400),
      child: RepTextFiled(
        icon: LineIcons.at,
        text: "Email ID",
        textEditingController: textEditingController,
        isPass: false,
      ),
    );
  }
}

// Top Login Text Components
class LoginText extends StatelessWidget {
  const LoginText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 2700),
      child: Container(
        margin: const EdgeInsets.only(right: 270, top: 10),
        width: gWidth / 4,
        height: gHeight / 18,
        child: const FittedBox(
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class TopImage extends StatelessWidget {
  const TopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 3300),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        width: gWidth,
        height: gHeight / 3.5,
        child: Image.asset(
          "assets/image/login.png",
        ),
      ),
    );
  }
}
