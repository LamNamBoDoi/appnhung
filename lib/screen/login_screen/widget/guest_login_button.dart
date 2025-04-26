import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/controller/user_logs_controller.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/screen/home_screen.dart';

class GuestLoginButton extends StatelessWidget {
  const GuestLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 500),
      child: SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => _showEmailDialog(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.teal[700],
              backgroundColor: Colors.teal.withOpacity(0.1),
              side: BorderSide(
                color: Colors.teal[700]!,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 24,
              ),
              elevation: 0,
              animationDuration: const Duration(milliseconds: 200),
              shadowColor: Colors.transparent,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, size: 20), // Thêm icon email
                SizedBox(width: 8), // Khoảng cách giữa icon và text
                Text('Đăng nhập dành cho sinh viên'),
              ],
            ),
          )),
    );
  }

  void _showEmailDialog(BuildContext context) {
    final emailController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_rounded,
                      color: Colors.teal[700],
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Đăng nhập bằng Email",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                "Vui lòng nhập email đã đăng ký để tiếp tục",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "example@domain.com",
                  prefixIcon:
                      Icon(Icons.email_outlined, color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal[400]!, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Hủy"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty ||
                            !emailController.text.contains('@')) {
                          Get.snackbar(
                            "Lỗi",
                            "Vui lòng nhập email hợp lệ",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                          return;
                        }

                        final userController = Get.find<UserController>();
                        if (userController.users.isEmpty) {
                          await Get.find<UserController>().getUser();
                          await Get.find<DevicesController>().getdevice();
                        }

                        List<User> users = userController.users;
                        bool isValidUser = false;

                        for (User user in users) {
                          if (user.email == emailController.text) {
                            isValidUser = true;
                            break;
                          }
                        }

                        if (isValidUser) {
                          userController.getInfoUser(emailController.text);
                          Get.find<UserLogsController>().getUsersLogs();
                          Get.offAll(() => HomeScreen(),
                              arguments: {'isAdmin': false});
                          Get.snackbar(
                            "Thành công",
                            "Đăng nhập với email ${emailController.text}",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                        } else {
                          Get.snackbar(
                            "Lỗi",
                            "Email không tồn tại trong hệ thống",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text("Xác nhận"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
