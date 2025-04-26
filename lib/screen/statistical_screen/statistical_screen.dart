import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/controller/user_logs_controller.dart';
import 'package:hethong/screen/statistical_screen/widget/bottom_sheet_attendance_days.dart';
import 'package:hethong/screen/statistical_screen/widget/filter_panel.dart';
import 'package:hethong/screen/statistical_screen/widget/user_attendance_card.dart';

class StatisticalScreen extends StatefulWidget {
  const StatisticalScreen({Key? key}) : super(key: key);

  @override
  State<StatisticalScreen> createState() => _StatisticalScreenState();
}

class _StatisticalScreenState extends State<StatisticalScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  List<String> _classList = [];
  String? _selectedClass;
  Map<String, String> classNameToCodeMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final devicesController = Get.find<DevicesController>();
      final userLogsController = Get.find<UserLogsController>();

      if (userLogsController.userlogs.isEmpty) {
        await userLogsController.getUsersLogs();
      }
      if (devicesController.devices.isEmpty) {
        await devicesController.getdevice();
      }

      setState(() {
        _classList = devicesController.devices
            .map((e) => e.device_name ?? '')
            .where((name) => name.isNotEmpty)
            .toList();

        // Tạo bản đồ tên lớp -> mã lớp
        classNameToCodeMap = {
          for (var device in devicesController.devices)
            device.device_name ?? '': device.device_dep ?? ''
        };

        // Set lớp mặc định
        _selectedClass = _classList.isNotEmpty ? _classList[0] : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê Điểm Danh',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilterPanel(
              selectedMonth: _selectedMonth,
              selectedYear: _selectedYear,
              selectedClass: _selectedClass,
              classList: _classList,
              onChangedMonth: (value) => setState(() => _selectedMonth = value),
              onChangedYear: (value) => setState(() => _selectedYear = value),
              onChangedClass: (value) => setState(() => _selectedClass = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<UserLogsController>(
                builder: (userLogController) {
                  final users = Get.find<UserController>()
                      .getUserFromMonth(_selectedMonth, _selectedYear)
                      .where((user) {
                    final userDeviceCode = user.device_dep ?? '';
                    final selectedClassCode =
                        classNameToCodeMap[_selectedClass ?? ''];
                    return userDeviceCode == selectedClassCode;
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      await Get.find<UserController>().getUser();
                      await Get.find<UserLogsController>().getUsersLogs();
                      setState(() {});
                    },
                    child: ListView.separated(
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final days = userLogController.getDayInMonthByUser(
                            user, _selectedMonth, _selectedYear);
                        final totalDays =
                            DateTime(_selectedYear, _selectedMonth + 1, 0).day;
                        final logs = userLogController.getLogsInMonthByUser(
                            user, _selectedMonth, _selectedYear);

                        return GestureDetector(
                          onTap: () => showAttendanceDetails(
                              context, user.username ?? '', days, logs),
                          child: UserAttendanceCard(
                            username: user.username ?? '',
                            attendedDays: days.length,
                            totalDays: totalDays,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
