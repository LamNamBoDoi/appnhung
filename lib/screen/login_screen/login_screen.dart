import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/auth_controller.dart';
import 'package:hethong/screen/login_screen/widget/divider_with_text.dart';
import 'package:hethong/screen/login_screen/widget/guest_login_button.dart';
import 'package:hethong/screen/login_screen/widget/login_button.dart';
import 'package:hethong/screen/login_screen/widget/top_image_widget.dart';
import 'package:hethong/widget/rep_textfiled.dart';
import 'package:line_icons/line_icons.dart';

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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.teal.shade50,
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TopImage(),
                  const LoginText(),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 20),
                  const DividerWithText(text: "Hoặc"),
                  const SizedBox(height: 20),
                  const GuestLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordTextFiled extends StatelessWidget {
  const PasswordTextFiled({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 600),
      child: RepTextFiled(
        icon: LineIcons.lock,
        text: "Mật khẩu",
        textEditingController: textEditingController,
        isPass: true,
      ),
    );
  }
}

class EmailTextFiled extends StatelessWidget {
  const EmailTextFiled({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 300),
      child: RepTextFiled(
        icon: LineIcons.envelope,
        text: "Email",
        textEditingController: textEditingController,
        isPass: false,
      ),
    );
  }
}

class LoginText extends StatelessWidget {
  const LoginText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 150),
      child: const Column(
        children: [
          Text(
            "Chào mừng trở lại",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Vui lòng đăng nhập để tiếp tục",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
