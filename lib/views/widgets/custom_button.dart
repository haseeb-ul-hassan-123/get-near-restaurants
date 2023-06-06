import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.buttonText,
      required this.onTap,
      this.radius = 8.0,
      this.textSize = 16.0,
      this.bordercolor,
      this.height = 48.0,
      this.width,
      this.phoneIcon,
      this.bgColor,
      this.textColor,
      this.iconWidth});
  final String buttonText;
  final VoidCallback onTap;
  double? radius, textSize, height, width, iconWidth;
  Color? bgColor, textColor, bordercolor;
  Widget? phoneIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
      shadowColor: Colors.black,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: bordercolor ?? kblackColor),
          borderRadius: BorderRadius.circular(radius!),
          color: bgColor ?? kPrimaryColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                phoneIcon ?? SizedBox(),
                SizedBox(
                  width: iconWidth ?? 0,
                ),
                Center(
                  child: CustomText(
                    text: buttonText,
                    size: 14,
                    color: textColor ?? kblackColor,
                    weight: FontWeight.bold,
                    overFlow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
