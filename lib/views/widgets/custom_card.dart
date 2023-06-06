import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    Key? key,
    required this.rImage,
    required this.rName,
    required this.rAddress,
    required this.rDistance,
    this.height,
    this.icon,
    this.width,
    this.likeIconTap,
  }) : super(key: key);
  final String rImage;
  final String rName;
  final String rAddress;
  final String rDistance;
  double? height, width;
  final IconData? icon;
  final VoidCallback? likeIconTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: kwhiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Image.network(
                rImage,
                fit: BoxFit.fill,
              )),
          SizedBox(
            width: getSizeWidth(context) * 0.02,
          ),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    text: rName,
                    size: 13,
                    weight: FontWeight.w600,
                  ),
                  CustomText(
                    text: rAddress,
                    size: 12,
                    weight: FontWeight.w400,
                  ),
                  CustomText(
                    text: rDistance,
                    size: 12,
                    weight: FontWeight.w400,
                  ),
                ],
              )),
          Expanded(
              flex: 2,
              child: InkWell(
                onTap: likeIconTap,
                child: Icon(
                  icon,
                  color: Colors.red,
                ),
              ))
        ],
      ),
    );
  }
}
