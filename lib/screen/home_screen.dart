import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/screen/admin_screen.dart';
import 'package:hethong/screen/class_screen.dart';
import 'package:hethong/screen/device_screen/devices_screen.dart';
import 'package:hethong/screen/info_attend_user_screen/info_attend_screen.dart';
import 'package:hethong/screen/info_user_screen/info_user.dart';
import 'package:hethong/screen/statistical_screen/statistical_screen.dart';
import 'package:hethong/screen/time_sheet_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _selectedIndex = 0.obs;
  final bool isAdmin = Get.arguments?['isAdmin'] ?? true;

  final List<Widget> _pages = [
    ClassScreen(),
    DeviceScreen(),
    TimeSheetScreen(),
    StatisticalScreen(),
    AdminScreen()
  ];

  final List<Widget> _pagesUser = [InfoUserScreen(), InfoAttendUserScreen()];

  @override
  Widget build(BuildContext context) {
    print("isAdmin: $isAdmin");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(
              milliseconds: 300), // Thêm hiệu ứng chuyển đổi mượt mà
          child: isAdmin
              ? _pages[_selectedIndex.value]
              : _pagesUser[_selectedIndex.value],
        ),
      ),
      // Hiển thị nội dung theo tab được chọn
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blueGrey[50], // Thêm màu nhẹ cho BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: isAdmin
              ? <Widget>[
                  Obx(() => _buildTabIcon(
                        icon: Icons.class_sharp,
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
                ]
              : <Widget>[
                  Obx(() => _buildTabIcon(
                        icon: Icons.person,
                        isSelected: _selectedIndex.value == 0,
                        onPressed: () => _selectedIndex.value = 0,
                      )),
                  Obx(() => _buildTabIcon(
                        icon: Icons.check_circle,
                        isSelected: _selectedIndex.value == 1,
                        onPressed: () {
                          _selectedIndex.value = 1;
                        },
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
