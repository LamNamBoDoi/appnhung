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
  final TextEditingController _searchController = TextEditingController();

  final UserLogsController userLogsController = Get.find<UserLogsController>();
  List<UserLogs> userLogsForSelectedDay = [];

  Future<void> _onRefresh() async {
    await userLogsController.getUsersLogs();
    setState(() {
      userLogsForSelectedDay = userLogsController.getLogsForDate(_selectedDay);
    });
  }

  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    userLogsController.getUsersLogs().then((_) {
      setState(() {
        userLogsForSelectedDay =
            userLogsController.getLogsForDate(DateTime.now());
      });
    });

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
    _searchController.dispose();
    super.dispose();
  }

  int _getUniqueUserCount(List<UserLogs> logs) {
    final usernames = <String>{};
    for (var log in logs) {
      if (log.username != null) {
        usernames.add(log.username!);
      }
    }
    return usernames.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GetBuilder<UserLogsController>(
          builder: (controller) {
            final viewInsets = MediaQuery.of(context).viewInsets.bottom;

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[700],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm theo tên...',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.teal[700]),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey[600]),
                                    onPressed: () {
                                      _searchController.clear();
                                      FocusScope.of(context).unfocus();
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),

                // Nội dung chính cuộn được
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: viewInsets),
                    child: RefreshIndicator(
                      color: Colors.teal,
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            if (_searchController.text.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: TableCalendar(
                                      firstDay: DateTime.utc(2010, 10, 16),
                                      lastDay: DateTime.utc(2030, 3, 14),
                                      focusedDay: _focuseDay,
                                      eventLoader: (day) {
                                        return userLogsController
                                                .attendanceDates
                                                .any((date) =>
                                                    date.year == day.year &&
                                                    date.month == day.month &&
                                                    date.day == day.day)
                                            ? [true]
                                            : [];
                                      },
                                      onPageChanged: (focusedDay) => setState(
                                          () => _focuseDay = focusedDay),
                                      selectedDayPredicate: (day) =>
                                          isSameDay(day, _selectedDay),
                                      onDaySelected: (selectedDay, focusedDay) {
                                        if (!isSameDay(
                                            _selectedDay, selectedDay)) {
                                          setState(() {
                                            _selectedDay = selectedDay;
                                            _focuseDay = focusedDay;
                                            userLogsForSelectedDay =
                                                userLogsController
                                                    .getLogsForDate(
                                                        selectedDay);
                                          });
                                        }
                                      },
                                      headerStyle: HeaderStyle(
                                        formatButtonVisible: false,
                                        titleCentered: true,
                                        titleTextStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                        leftChevronIcon: Icon(
                                          Icons.chevron_left,
                                          color: Colors.teal[700],
                                        ),
                                        rightChevronIcon: Icon(
                                          Icons.chevron_right,
                                          color: Colors.teal[700],
                                        ),
                                      ),
                                      calendarStyle: CalendarStyle(
                                        weekendTextStyle:
                                            const TextStyle(color: Colors.red),
                                        todayTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        todayDecoration: BoxDecoration(
                                          color: Colors.teal[400],
                                          shape: BoxShape.circle,
                                        ),
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.white),
                                        selectedDecoration: BoxDecoration(
                                          color: Colors.teal[700],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (_searchController.text.isEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Ngày ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal[700],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${_getUniqueUserCount(userLogsForSelectedDay)} người',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                            userLogsForSelectedDay.isEmpty
                                ? _buildEmptyState()
                                : _buildLogsList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 60,
            color: Colors.teal[300],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'Không có logs cho ngày này'
                : 'Không tìm thấy kết quả phù hợp',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    final filteredLogs = _searchController.text.isEmpty
        ? userLogsForSelectedDay
        : userLogsForSelectedDay
            .where((log) => log.username!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();

    if (filteredLogs.isEmpty) return _buildEmptyState();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredLogs.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (context, index) {
        final log = filteredLogs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: Colors.teal[700]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.username!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.login,
                                  size: 14, color: Colors.green[600]),
                              const SizedBox(width: 4),
                              Text(
                                log.timein ?? '--:--',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.logout,
                                  size: 14, color: Colors.red[600]),
                              const SizedBox(width: 4),
                              Text(
                                log.timeout ?? '--:--',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle, color: Colors.teal[400]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
