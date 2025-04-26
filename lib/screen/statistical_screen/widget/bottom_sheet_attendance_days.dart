import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hethong/data/model/body/users_logs.dart';
import 'package:hethong/screen/statistical_screen/widget/itemLog.dart';

void showAttendanceDetails(BuildContext context, String username,
    Set<String> attendanceDays, List<UserLogs> logs) {
  final sortedDays = attendanceDays.toList()
    ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));

  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Text('Ngày điểm danh của $username',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: sortedDays.isEmpty
                  ? const Center(child: Text('Không có dữ liệu điểm danh'))
                  : ListView.builder(
                      itemCount: sortedDays.length,
                      itemBuilder: (_, i) {
                        final date = DateTime.parse(sortedDays[i]);
                        final formatted =
                            DateFormat('EEEE, dd MMMM, yyyy', 'vi_VN')
                                .format(date);
                        final logsOfDay = logs
                            .where((e) => e.checkindate == sortedDays[i])
                            .toList();

                        return AttendanceDayItem(
                          rawDate: sortedDays[i],
                          formattedDate: formatted,
                          logs: logsOfDay,
                        );
                      },
                    ),
            )
          ],
        ),
      );
    },
  );
}
