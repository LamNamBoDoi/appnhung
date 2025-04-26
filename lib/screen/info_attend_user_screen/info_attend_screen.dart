import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/controller/user_logs_controller.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/data/model/body/users_logs.dart';
import 'package:hethong/screen/statistical_screen/widget/bottom_sheet_attendance_days.dart';
import 'package:hethong/screen/statistical_screen/widget/dropdown_style.dart';
import 'package:get/get.dart';
import 'package:hethong/screen/statistical_screen/widget/user_attendance_card.dart';

class InfoAttendUserScreen extends StatefulWidget {
  const InfoAttendUserScreen({super.key});

  @override
  State<InfoAttendUserScreen> createState() => _InfoAttendUserScreenState();
}

class _InfoAttendUserScreenState extends State<InfoAttendUserScreen> {
  final months = List.generate(12, (i) => 'Tháng ${i + 1}');
  final years = List.generate(12, (i) => DateTime.now().year - 10 + i);
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  final userLogController = Get.find<UserLogsController>();
  final userController = Get.find<UserController>();
  Set<String> daysAttendence = {};
  User user = User();
  int totalDays = 1;
  List<UserLogs> userLogs = [];

  void loadData() {
    user = userController.user;

    final fetchedDays = userLogController.getDayInMonthByUser(
        user, selectedMonth, selectedYear);
    final fetchedLogs = userLogController.getLogsInMonthByUser(
        user, selectedMonth, selectedYear);
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

    setState(() {
      daysAttendence = fetchedDays;
      userLogs = fetchedLogs;
      totalDays = daysInMonth;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void onChangedMonth(int month) {
    if (month >= 1 && month <= 12) {
      setState(() {
        selectedMonth = month;
      });
      loadData();
    }
  }

  void onChangedYear(int year) {
    if (year > 0) {
      setState(() {
        selectedYear = year;
      });
      loadData();
    }
  }

  bool isBeforeUserCreation() {
    DateTime startDate = DateTime(selectedYear, selectedMonth + 1, 1);
    DateTime userDate = DateTime.parse(user.user_date!);
    return !userDate.isAfter(startDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin điểm danh',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await userLogController.getUsersLogs();
          loadData();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GetBuilder<UserLogsController>(
                    builder: (userLogsController) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Text('Chọn tháng'),
                                      items: months
                                          .asMap()
                                          .entries
                                          .map((entry) =>
                                              DropdownMenuItem<String>(
                                                value: entry.key.toString(),
                                                child: Text(entry.value),
                                              ))
                                          .toList(),
                                      value: (selectedMonth - 1).toString(),
                                      onChanged: (value) =>
                                          onChangedMonth(int.parse(value!) + 1),
                                      buttonStyleData: dropdownButtonStyle(),
                                      iconStyleData: dropdownIconStyle(),
                                      dropdownStyleData: dropdownStyle(context),
                                      menuItemStyleData: dropdownMenuStyle(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Text('Chọn năm'),
                                      items: years
                                          .map((year) =>
                                              DropdownMenuItem<String>(
                                                value: year.toString(),
                                                child: Text(year.toString()),
                                              ))
                                          .toList(),
                                      value: selectedYear.toString(),
                                      onChanged: (value) =>
                                          onChangedYear(int.parse(value!)),
                                      buttonStyleData: dropdownButtonStyle(),
                                      iconStyleData: dropdownIconStyle(),
                                      dropdownStyleData: dropdownStyle(context),
                                      menuItemStyleData: dropdownMenuStyle(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isBeforeUserCreation())
                            GestureDetector(
                              onTap: () => showAttendanceDetails(
                                  context,
                                  user.username ?? '',
                                  daysAttendence,
                                  userLogs),
                              child: UserAttendanceCard(
                                username: user.username ?? '',
                                attendedDays: daysAttendence.length,
                                totalDays: totalDays,
                              ),
                            )
                          else
                            const SizedBox(
                              height: 80,
                              child: Center(
                                  child: Text("Không có dữ liệu điểm danh")),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
