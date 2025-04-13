import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/auth_controller.dart';
import 'package:hethong/screen/login_screen.dart';

class AdminScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Gán giá trị mặc định cho các trường text

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Admin Panel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Đăng xuất và chuyển hướng đến màn hình đăng nhập
                Get.off(() => LoginScreen());
              },
            ),
          ],
        ),
        body: GetBuilder<AuthController>(builder: (_) {
          nameController.text = authController.admin.admin_name!;
          emailController.text = authController.admin.admin_email!;

          return RefreshIndicator(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // Tên người dùng
                  _buildTextField(
                    controller: nameController,
                    labelText: 'Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  _buildTextField(
                    controller: emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  // Mật khẩu cũ
                  _buildTextField(
                    controller: passwordController,
                    labelText: 'Current Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Mật khẩu mới
                  _buildTextField(
                    controller: newPasswordController,
                    labelText: 'New Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Nút lưu
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Màu nút
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Đường bo tròn cho nút
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      if (passwordController.text.isNotEmpty) {
                        // Gọi API để cập nhật thông tin admin
                        bool success = await authController.updateAdminInfo(
                          nameController.text,
                          emailController.text,
                          passwordController.text, // mật khẩu cũ
                          newPasswordController.text, // mật khẩu mới
                        );
                        if (success) {
                          // Nếu cập nhật thành công, cập nhật lại thông tin admin
                          authController.admin.admin_name = nameController.text;
                          authController.admin.admin_email =
                              emailController.text;
                          passwordController.text = '';
                          newPasswordController.text = '';
                          // Hiển thị thông báo thành công
                          Get.snackbar(
                            'Thông tin đã được cập nhật.',
                            authController.message.value,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        } else {
                          // Nếu thất bại, hiển thị thông báo lỗi
                          Get.snackbar(
                            'Cập nhật thông tin thất bại.',
                            authController.message.value,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        }
                      } else {
                        // Nếu mật khẩu cũ trống, hiển thị thông báo
                        Get.snackbar(
                          "Mật khẩu không được bỏ trống",
                          authController.message.value,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
            onRefresh: () async {
              // Gọi lại getUser để tải lại dữ liệu khi kéo xuống
              await authController.getAdmin();
            },
          );
        }));
  }

  // Hàm tạo TextField với trang trí đẹp hơn
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal), // Màu của icon
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.teal, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Đường viền bo tròn
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.blue, width: 2), // Màu khi focus vào trường
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.grey, width: 1.5), // Màu viền khi không focus
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
