import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomPopUp extends StatelessWidget {
  CustomPopUp({
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
                CustomText(
                  text: '$heading',
                  size: 18,
                  weight: FontWeight.w600,
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: getSizeHeight(context) * 0.06,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonText: 'No',
                        radius: 40,
                        onTap: onNoTap ?? () {},
                        bgColor: Colors.white,
                        bordercolor: Colors.transparent,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        buttonText: 'Yes',
                        radius: 40,
                        onTap: onYesTap ?? () {},
                        bgColor: kPrimaryColor,
                        bordercolor: Colors.transparent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
