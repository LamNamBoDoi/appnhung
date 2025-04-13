import 'package:get/get.dart';
import 'package:hethong/screen/home_screen.dart';
import 'package:hethong/screen/login_screen.dart';
import 'package:hethong/screen/splash_screen.dart';
import 'package:hethong/screen/user_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String signIn = '/sign-in';
  static const String user = '/user';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String login = '/login';

  static String getInitialRoute() => '$initial';
  static String getSignInRoute() => '$signIn';
  static String getUserRoute() => '$user';
  static String getHomeRoute() => '$home';
  static String getSplashRoute() => '$splash';
  static String getLoginRoute() => '$login';

  static List<GetPage> routes = [
    GetPage(name: user, page: () => UserScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
  ];
}
