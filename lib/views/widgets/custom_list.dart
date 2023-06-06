import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomList extends StatelessWidget {
  CustomList({
    Key? key,
    required this.listType,
    this.height,
    this.width,
    this.iconColor,
    this.preIcon,
    this.textColor,
    this.postIcon,
  }) : super(key: key);
  final String listType;
  final String? preIcon;
  final IconData? postIcon;
  double? height, width;
  final Color? iconColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      height: height,
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: getSizeWidth(context) * 0.05,
          ),
          SvgPicture.asset(
            height: 20,
            width: 20,
            preIcon ?? Assets.profile,
          ),
          SizedBox(
            width: getSizeWidth(context) * 0.05,
          ),
          CustomText(
            text: listType,
            size: 14,
            color: textColor,
            weight: FontWeight.w400,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              postIcon,
              color: iconColor ?? Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
