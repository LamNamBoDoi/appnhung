import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/data/model/body/user.dart';
import 'package:hethong/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController implements GetxService {
  bool _loading = false;
  List<User> _users = <User>[];
  User _user = User();
  User get user => _user;
  bool get loading => _loading;
  List<User> get users => _users;

  void onInit() async {
    super.onInit();
    await getUser();
  }

  // Phương thức kiểm tra nếu số serial đã tồn tại
  bool isSerialNumberExists(String serialNumber, String excludeUserId) {
    return users.any((user) =>
        user.serialnumber == serialNumber && user.id != excludeUserId);
  }

  Future<void> getUser() async {
    _loading = true;
    try {
      var url = Uri.parse(AppConstants.BASE_URL + AppConstants.GET_USER);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        _users =
            responseData.map((userData) => User.fromJson(userData)).toList();
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

  // Xóa người dùng
  Future<void> deleteUser(String userId) async {
    _loading = true;
    update();

    try {
      var url = Uri.parse(AppConstants.BASE_URL + AppConstants.DELETE_USER);
      var response = await http.get(Uri.parse(
          '$url?id=$userId')); // Gửi yêu cầu xóa qua GET với tham số id

      if (response.statusCode == 200) {
        // Xử lý phản hồi từ server (nếu có)
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Nếu xóa thành công, loại bỏ người dùng khỏi danh sách
          _users.removeWhere((user) => user.id == userId);
          Get.snackbar(
            'Xóa thành công',
            'User đã được xóa khỏi danh sách',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Xóa thất bại',
            'User không tồn tại hoặc không thể xóa',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 1),
          );
        }
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print("Error deleting user: $e");
      Get.snackbar('Error', 'Failed to delete user');
    } finally {
      _loading = false;
      await getUser();
      update();
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(User user) async {
    _loading = true;
    update();

    try {
      // Tạo một đối tượng Map từ User
      final Map<String, String> userData = {
        'id': user.id!,
        'username': user.username!,
        'serialnumber': user.serialnumber!,
        'gender': user.gender!,
        'email': user.email!,
        'card_uid': user.card_uid!,
        'card_select': user.card_select!,
        'user_date': user.user_date!,
        'device_uid': user.device_uid!,
        'device_dep': user.device_dep!,
        'add_card': user.add_card!,
      };

      // Gửi yêu cầu PUT lên API
      final response = await http.put(
        Uri.parse(AppConstants.BASE_URL + AppConstants.UPDATE_USER),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Kiểm tra kết quả trả về từ server
        if (responseBody['message'] == 'User updated successfully') {
          // Cập nhật lại danh sách người dùng
          int index = _users.indexWhere((u) => u.id == user.id);
          if (index != -1) {
            _users[index] = user; // Cập nhật người dùng trong danh sách
          }

          Get.snackbar(
            'Success',
            'User updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to update user',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        }
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Failed to update user');
    } finally {
      _loading = false;
      update();
    }
  }

  List<User> getUserFromMonth(int month, int year) {
    List<User> newUsers = [];

    DateTime startDate = DateTime(year, month + 1, 1);
    for (User user in _users) {
      if (user.user_date != null) {
        try {
          DateTime userDate = DateTime.parse(user.user_date!);
          print(userDate);
          if (!userDate.isAfter(startDate)) {
            newUsers.add(user);
          }
        } catch (e) {
          print("Lỗi khi parse ngày: ${user.user_date}");
        }
      }
    }

    print("Tổng user sau tháng $month/$year: ${newUsers.length}");
    return newUsers;
  }

  List<User> getStudentCountByClass(String device_dep) {
    List<User> newUsers = [];
    if (_users.isEmpty) {
      getUser();
    }
    for (User user in _users) {
      if (user.device_dep == device_dep) {
        newUsers.add(user);
      }
    }
    return newUsers;
  }

  List<User> getNewUsers() {
    List<User> newUsers = [];
    getUser();
    for (User user in _users) {
      if (user.username == "None" &&
          user.gender == "None" &&
          user.serialnumber == "0") {
        newUsers.add(user);
        print(user.username);
      }
    }
    return newUsers;
  }

  void getInfoUser(String email) async {
    if (_users.isEmpty) {
      await getUser();
    }
    _user = _users.firstWhere((user) => user.email == email);
    update();
  }
}
