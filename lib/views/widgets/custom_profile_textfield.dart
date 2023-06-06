import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';

class CustomProfileTextfield extends StatelessWidget {
  CustomProfileTextfield({
    Key? key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.icon,
    this.read = true,
    this.marginBottom = 15.0,
    this.isObSecure = false,
    this.maxLength,
    this.maxLines = 1,
    this.intialvalue,
    this.onsaved,
    this.formFieldValidator,
  }) : super(key: key);
  String? hintText;
  TextEditingController? controller;
  TextInputType? keyboardType;
  double? marginBottom;
  bool? isObSecure;
  String? icon;
  bool? read;
  int? maxLength, maxLines;
  String? intialvalue;
  FormFieldValidator? formFieldValidator;
  final String Function(String?)? onsaved;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom!,
      ),
      child: TextFormField(
        initialValue: intialvalue,
        onSaved: onsaved,
        maxLines: maxLines,
        validator: formFieldValidator,
        readOnly: read!,
        maxLength: maxLength,
        obscureText: isObSecure!,
        obscuringCharacter: '*',
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        style: TextStyle(
            color: kblackColor, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          hintText: hintText,
          counterText: '',
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
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}
