import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hethong/helper/get_di.dart';
import 'package:hethong/helper/route_helper.dart';

void main() {
  runApp(const MyApp());
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
