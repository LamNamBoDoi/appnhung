import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/screen/admin_screen.dart';
import 'package:hethong/screen/devices_screen.dart';
import 'package:hethong/screen/statistical_screen.dart';
import 'package:hethong/screen/time_sheet_screen.dart';
import 'package:hethong/screen/user_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _selectedIndex = 0.obs;

  // Danh sách các widget cho mỗi tab
  final List<Widget> _pages = [
    UserScreen(),
    DeviceScreen(),
    TimeSheetScreen(),
    StatisticalScreen(),
    AdminScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(
              milliseconds: 300), // Thêm hiệu ứng chuyển đổi mượt mà
          child: _pages[_selectedIndex.value],
        ),
      ),
      // Hiển thị nội dung theo tab được chọn
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blueGrey[50], // Thêm màu nhẹ cho BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Obx(() => _buildTabIcon(
                  icon: Icons.check,
                  isSelected: _selectedIndex.value == 0,
                  onPressed: () => _selectedIndex.value = 0,
                )),
            Obx(() => _buildTabIcon(
                  icon: Icons.track_changes,
                  isSelected: _selectedIndex.value == 1,
                  onPressed: () => _selectedIndex.value = 1,
                )),
            Obx(() => _buildTabIcon(
                  icon: Icons.school,
                  isSelected: _selectedIndex.value == 2,
                  onPressed: () => _selectedIndex.value = 2,
                )),
            Obx(() => _buildTabIcon(
                  icon: Icons.pie_chart,
                  isSelected: _selectedIndex.value == 3,
                  onPressed: () => _selectedIndex.value = 3,
                )),
            Obx(() => _buildTabIcon(
                  icon: Icons.people,
                  isSelected: _selectedIndex.value == 4,
                  onPressed: () => _selectedIndex.value = 4,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTabIcon({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        size: 28,
        color:
            isSelected ? Colors.teal : Colors.grey, // Chọn màu phù hợp cho icon
      ),
      onPressed: onPressed,
    );
  }
}
