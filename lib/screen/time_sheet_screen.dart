import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hethong/controller/user_logs_controller.dart';
import 'package:hethong/data/model/body/users_logs.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focuseDay = DateTime.now();

  final UserLogsController userLogsController = Get.find<UserLogsController>();
  List<UserLogs> userLogsForSelectedDay = [];

  Future<void> _onRefresh() async {
    await userLogsController.getUsersLogs(); // reload user logs
    setState(() {
      userLogsForSelectedDay = userLogsController
          .getLogsForDate(_selectedDay); // filter by selected day
    });
  }

  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    // Initial load of logs for the current day
    userLogsController.getUsersLogs().then((_) {
      setState(() {
        userLogsForSelectedDay =
            userLogsController.getLogsForDate(DateTime.now());
      });
    });

    // Thiết lập auto refresh mỗi 5 giây
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await userLogsController.getUsersLogs();
      setState(() {
        userLogsForSelectedDay =
            userLogsController.getLogsForDate(_selectedDay);
      });
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('Timesheet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        body: GetBuilder<UserLogsController>(builder: (controller) {
          return Stack(
            children: [
              Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focuseDay,
                    eventLoader: (day) {
                      return userLogsController.attendanceDates.any((date) =>
                              date.year == day.year &&
                              date.month == day.month &&
                              date.day == day.day)
                          ? [true] // có sự kiện
                          : [];
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focuseDay = focusedDay;
                      });
                    },
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focuseDay = focusedDay;
                          userLogsForSelectedDay =
                              userLogsController.getLogsForDate(selectedDay);
                        });
                      }
                    },
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    availableGestures: AvailableGestures.all,
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      todayTextStyle: const TextStyle(color: Colors.black),
                      selectedDecoration: const BoxDecoration(
                          color: Colors.teal, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.teal,
                        ),
                        child: RefreshIndicator(
                          onRefresh: _onRefresh, // refresh function
                          child: userLogsForSelectedDay.isEmpty
                              ? ListView(
                                  children: const [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          'Không có logs cho ngày này',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: userLogsForSelectedDay.length,
                                  itemBuilder: (context, index) {
                                    final log = userLogsForSelectedDay[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                        leading: const Icon(Icons.access_time,
                                            color: Colors.teal),
                                        title: Text(
                                          log.username!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Thời gian vào: ${log.timein}',
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    'Thời gian ra: ${log.timeout}',
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        }));
  }
}
