import 'dart:convert';

import 'package:get/get.dart';
import 'package:hethong/data/model/body/users_logs.dart';
import 'package:hethong/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserLogsController extends GetxController implements GetxService {
  bool _loading = false;
  List<UserLogs> _userlogs = <UserLogs>[];

  bool get loading => _loading;
  List<UserLogs> get userlogs => _userlogs;

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

  void addUserLog(UserLogs log) {
    _userlogs.insert(0, log); // chèn vào đầu danh sách
    update();
  }
}
