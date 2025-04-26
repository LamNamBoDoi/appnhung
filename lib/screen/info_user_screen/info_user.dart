import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/screen/login_screen/login_screen.dart';
import 'package:intl/intl.dart';

class InfoUserScreen extends StatelessWidget {
  const InfoUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Get.off(() => LoginScreen());
            },
          ),
        ],
        title: const Text('Thông tin sinh viên',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildUserHeader(user, theme),
            const SizedBox(height: 24),
            _buildInfoCard(
              theme: theme,
              title: 'Thông tin cá nhân',
              icon: Icons.person_outline,
              children: [
                _buildInfoItem('Họ và tên', user.username),
                _buildInfoItem('Số serial', user.serialnumber),
                _buildInfoItem('Giới tính', user.gender),
                _buildInfoItem('Email', user.email),
                _buildInfoItem(
                  'Ngày tạo',
                  user.user_date != null
                      ? DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(user.user_date!))
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              theme: theme,
              title: 'Thông tin thẻ',
              icon: Icons.credit_card,
              children: [
                _buildInfoItem('Mã thẻ', user.card_uid),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              theme: theme,
              title: 'Thông tin thiết bị',
              icon: Icons.devices_other,
              children: [
                _buildInfoItem(
                  'Lớp học',
                  Get.find<DevicesController>()
                      .getNameDevice(user.device_dep ?? ""),
                ),
                _buildInfoItem('Mã lớp học', user.device_dep),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(User user, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal[400]!, Colors.teal[700]!],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          user.username ?? 'Không có tên',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        if (user.email != null) ...[
          const SizedBox(height: 8),
          Text(
            user.email!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.teal[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    if (value == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
