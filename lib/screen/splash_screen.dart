import 'package:flutter/material.dart';
import 'package:hethong/screen/login_screen/login_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/animation/Animation - 1735542807872.json'),
      ),
      nextScreen: LoginScreen(),
      splashIconSize: 160,
    );
  }
}
