import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  const TopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Image.asset(
          "assets/image/login.png",
          width: 250,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
