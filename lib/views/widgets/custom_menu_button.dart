import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class CustomMenuButton extends StatelessWidget {
  final String list1;
  final String list2;
  final String list3;
  final void Function(int) onSelected;
  const CustomMenuButton(
      {Key? key,
      required this.list1,
      required this.onSelected,
      required this.list2,
      required this.list3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: Icon(
        Icons.more_vert,
        size: 28,
        color: kblackColor,
      ), // customize the icon here
      itemBuilder: buildPopupMenuItems,
      onSelected: onSelected,
    );
    ;
  }

  List<PopupMenuEntry<int>> buildPopupMenuItems(BuildContext context) {
    return [
      PopupMenuItem(
        height: getSizeHeight(context) * 0.040,
        child: CustomText(
          text: list1,
          color: kblackColor,
          size: 12,
          weight: FontWeight.w400,
        ),
        value: 1,
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        height: getSizeHeight(context) * 0.040,
        child: CustomText(
          text: list2,
          color: kblackColor,
          size: 12,
          weight: FontWeight.w400,
        ),
        value: 2,
      ),
      PopupMenuDivider(),
      PopupMenuItem(
        height: getSizeHeight(context) * 0.040,
        child: CustomText(
          text: list3,
          color: kblackColor,
          size: 12,
          weight: FontWeight.w400,
        ),
        value: 3,
      ),
    ];
  }
}
