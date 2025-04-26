import 'dart:convert';

import 'package:get/get.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/data/model/body/users_logs.dart';
import 'package:hethong/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserLogsController extends GetxController implements GetxService {
  bool _loading = false;
  List<UserLogs> _userlogs = <UserLogs>[];
  List<DateTime> _attendanceDates = [];
  List<DateTime> get attendanceDates => _attendanceDates;
  bool get loading => _loading;
  List<UserLogs> get userlogs => _userlogs;

  get userLogs => _userlogs;
  Future<void> getUsersLogs() async {
    _loading = true;
    update();

    try {
      var url = Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER_LOGS);

      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);
        _userlogs = responseData
            .map((userlogsData) => UserLogs.fromJson(userlogsData))
            .toList();
        final Set<String> seenDates = {};
        _attendanceDates.clear();
        for (var log in _userlogs) {
          if (log.checkindate != null) {
            String dateStr = log.checkindate!;
            if (!seenDates.contains(dateStr)) {
              seenDates.add(dateStr);
              DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateStr);
              _attendanceDates.add(parsedDate);
            }
          }
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      _loading = false;
      update();
    }
  }

  List<UserLogs> getLogsForDate(DateTime date) {
    getUsersLogs();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return _userlogs.where((log) {
      String logDate = log.checkindate!;
      return logDate == formattedDate;
    }).toList();
  }

  Set<String> getDayInMonthByUser(User user, int month, int year) {
    final Set<String> userAttendanceDays = {};
    if (_userlogs.isEmpty) {
      getUsersLogs();
    }
    for (UserLogs userLog in _userlogs) {
      final date = userLog.checkindate != null
          ? DateTime.parse(userLog.checkindate!)
          : null;
      // Kiểm tra tháng và năm khớp
      if (date?.month == month &&
          date?.year == year &&
          userLog.card_uid == user.card_uid) {
        if (userLog.checkindate != null) {
          userAttendanceDays.add(userLog.checkindate!);
        }
      }
    }

    return userAttendanceDays;
  }

  List<UserLogs> getLogsInMonthByUser(User user, int month, int year) {
    final List<UserLogs> userLogsInMonth = [];
    if (_userlogs.isEmpty) {
      getUsersLogs();
    }
    for (UserLogs userLog in _userlogs) {
      final date = userLog.checkindate != null
          ? DateTime.parse(userLog.checkindate!)
          : null;
      if (date?.month == month &&
          date?.year == year &&
          userLog.card_uid == user.card_uid) {
        if (userLog.checkindate != null) {
          userLogsInMonth.add(userLog);
        }
      }
    }
    return userLogsInMonth;
  }
}
