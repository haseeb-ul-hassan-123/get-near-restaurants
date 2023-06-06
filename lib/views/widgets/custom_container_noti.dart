import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomContainerNoti extends StatelessWidget {
  CustomContainerNoti({
    Key? key,
    required this.rImage,
    required this.rName,
    required this.price,
    this.height,
    this.width,
    this.icon,
  }) : super(key: key);
  final String rImage;
  final String rName;
  final String price;
  final IconData? icon;

  double? height, width;
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
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.network(
                  rImage,
                  fit: BoxFit.fill,
                ),
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
                    text: price,
                    size: 12,
                    maxLines: 2,
                    weight: FontWeight.w400,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
