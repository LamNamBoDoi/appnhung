import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/auth_controller.dart';
import 'package:hethong/screen/home_screen.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
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
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (authController.isLoading.value) return;

            final email = emailController.text;
            final password = passwordController.text;

            authController.login(email, password).then((_) {
              if (authController.message.value.startsWith("Chào mừng")) {
                Get.snackbar(
                  "Đăng nhập thành công",
                  authController.message.value,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                Get.off(() => HomeScreen());
              } else {
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
                : const Text(
                    "ĐĂNG NHẬP",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
        ),
      ),
    );
  }
}
