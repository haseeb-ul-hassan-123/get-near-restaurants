import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.title,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.haveLabel = true,
  });

  final List<dynamic>? items;
  String? selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String title;
  bool? haveLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        haveLabel!
            ? CustomText(
                text: title,
                weight: FontWeight.w600,
                paddingBottom: 6,
              )
            : SizedBox(),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: CustomText(
              text: 'Select Option',
              size: 12,
              color: Colors.grey,
            ),
            items: items!
                .map(
                  (item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: CustomText(
                      text: item,
                      size: 14,
                      color: Colors.black,
                    ),
                  ),
                )
                .toList(),
            value: selectedValue,
            onChanged: onChanged,
            icon: ImageIcon(
              size: 16,
              AssetImage(
                Assets.dropdown,
              ),
            ),
            isDense: true,
            isExpanded: true,
            buttonHeight: 45,
            buttonPadding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.transparent,
                border: Border.all(color: Colors.grey)),
            buttonElevation: 0,
            itemHeight: 40,
            itemPadding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            dropdownWidth: MediaQuery.of(context).size.width * 0.92,
            dropdownPadding: null,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            dropdownElevation: 4,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
          ),
        ),
      ],
    );
  }
}
