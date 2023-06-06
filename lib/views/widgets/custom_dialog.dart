import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    Key? key,
    this.content,
    this.heading,
    this.onYesTap,
    this.image,
    this.onNoTap,
  }) : super(key: key);
  String? heading, content;
  VoidCallback? onYesTap, onNoTap;
  String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kwhiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: getSizeHeight(context) * 0.01,
                ),
                Image.asset(
                  image ?? 'assets/images/lockdialog.png',
                  height: getSizeHeight(context) * 0.2,
                  width: getSizeWidth(context) * 0.3,
                ),
                SizedBox(
                  height: getSizeHeight(context) * 0.03,
                ),
                CustomText(
                  text: '$heading',
                  size: 18,
                  weight: FontWeight.w600,
                  align: TextAlign.center,
                ),
                CustomText(
                  paddingTop: 15,
                  text: '$content',
                  size: 12,
                  weight: FontWeight.w300,
                  align: TextAlign.center,
                  paddingBottom: 15,
                ),
                SizedBox(
                  height: getSizeHeight(context) * 0.01,
                ),
                CustomButton(
                  buttonText: 'Done',
                  radius: 40,
                  onTap: onYesTap ?? () {},
                  bgColor: kPrimaryColor,
                  bordercolor: Colors.transparent,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
