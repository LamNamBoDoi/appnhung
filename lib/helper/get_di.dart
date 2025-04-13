import 'package:get/get.dart';
import 'package:hethong/controller/auth_controller.dart';
import 'package:hethong/controller/devices_controller.dart';
import 'package:hethong/controller/user_controller.dart';
import 'package:hethong/controller/user_logs_controller.dart';

void init() async {
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => DevicesController());
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => UserLogsController());
}
