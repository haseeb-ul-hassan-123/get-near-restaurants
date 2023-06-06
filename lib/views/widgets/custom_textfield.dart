import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      this.controller,
      this.keyboardType,
      this.hintText,
      this.icon,
      this.marginBottom = 15.0,
      this.isObSecure = false,
      this.maxLength,
      this.suffixIcon,
      this.maxLines = 1,
      this.onchanged,
      this.formFieldValidator})
      : super(key: key);
  String? hintText;
  TextEditingController? controller;
  TextInputType? keyboardType;
  double? marginBottom;
  bool? isObSecure;

  String? icon;
  Widget? suffixIcon;
  int? maxLength, maxLines;
  FormFieldValidator? formFieldValidator;
  dynamic? onchanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom!,
      ),
      child: ClipRRect(
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLines,
          maxLength: maxLength,
          obscureText: isObSecure!,
          obscuringCharacter: '*',
          controller: controller,
          validator: formFieldValidator,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          onChanged: onchanged ?? (value) {},
          style: GoogleFonts.inter(
              color: kblackColor, fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            prefixIcon: Center(
              child: SvgPicture.asset(
                height: 20,
                width: 20,
                icon ?? Assets.profile,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 23,
              maxWidth: 47,
            ),
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
            fillColor: kwhiteColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(40),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(40),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(40),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(40),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
    );
  }
}
