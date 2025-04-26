import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/helper/get_di.dart';
import 'package:hethong/helper/route_helper.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runApp(const MyApp());
  await initializeDateFormatting('vi_VN', null);
  init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteHelper.getSplashRoute(),
      getPages: RouteHelper.routes,
    );
  }
}
