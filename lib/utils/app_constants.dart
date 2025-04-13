import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConstants {
  static const String BASE_URL = 'http://192.168.1.160/webdiemdanh';
  static const String GET_USER = '/readUser.php';
  static const String GET_DEVICES = '/readDevice.php';
  static const String GET_USER_LOGS = '/read_userlogs.php';
  static const String LOGIN = '/readAdmin.php';
  static const String UPDATEADMIN = '/update_admin.php';
  static const String GETADMIN = '/get_admin.php';
  static const String UPDATEDEVICE = '/update_device.php';
  static const String DELETE_USER = '/delete_user.php';
  static const String UPDATE_USER = '/update_user.php';
}

final gWidth = Get.width;
final gHeight = Get.height;
final Color buttonColor = Color(0xff0065FF);
final Color iconColor = Color(0xff7E899D);
final Color text1Color = Color.fromARGB(255, 90, 90, 90);
