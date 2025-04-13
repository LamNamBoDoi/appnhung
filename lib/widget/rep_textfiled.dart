import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_constants.dart';

class RepTextFiled extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextEditingController textEditingController;
  final bool isPass;
  final RxBool isPasswordVisible = false.obs;

  RepTextFiled({
    required this.icon,
    required this.text,
    required this.textEditingController,
    required this.isPass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: gHeight / 15,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              SizedBox(width: 10),
              Container(
                height: 50,
                width: gWidth / 1.3,
                child: isPass
                    ? Obx(() {
                        return TextField(
                            controller: textEditingController,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            obscureText: isPass && !isPasswordVisible.value,
                            decoration: InputDecoration(
                                suffixIcon: isPass
                                    ? IconButton(
                                        icon: Icon(
                                          isPasswordVisible.value
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          isPasswordVisible.value =
                                              !isPasswordVisible.value;
                                        },
                                      )
                                    : null,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                ),
                                labelText: text,
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )));
                      })
                    : TextField(
                        controller: textEditingController,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                            labelText: text,
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ))),
              ),
            ],
          ),
        ));
  }
}
