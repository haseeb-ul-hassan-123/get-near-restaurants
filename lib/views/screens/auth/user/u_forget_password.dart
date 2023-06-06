import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/flashbar.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/validate.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../constant/provider_setup.dart';

class UForgetPassword extends StatefulWidget {
  const UForgetPassword({Key? key}) : super(key: key);

  @override
  State<UForgetPassword> createState() => _UForgetPasswordState();
}

class _UForgetPasswordState extends State<UForgetPassword> {
  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  String initialCountry = 'PK';
  var _signUpformKey = GlobalKey<FormState>();
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  String phoneNumber = '';
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CustomText(
                text: 'Forget Password',
                size: 28,
                weight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: getSizeHeight(context) * 0.06,
            ),
            Container(
              height: getCustomSize(context).height * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getSizeHeight(context) * 0.03,
                        ),
                        Center(
                          child: CustomText(
                            text:
                                'Please enter your phone number so we\n  can help you recover your password',
                            size: 16,
                            weight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: getSizeHeight(context) * 0.12,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CustomText(
                              text: 'Phone Number',
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getSizeHeight(context) * 0.015,
                        ),
                        IntlPhoneField(
                          flagsButtonPadding: EdgeInsets.only(left: 10),
                          decoration: InputDecoration(
                            hintText: "Enter Phone number",
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
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
                          validator: (value) {
                            if (value!.number.isEmpty) {
                              return "Please Enter phone number";
                            }
                          },

                          controller: _phoneNumberController,
                          showDropdownIcon: true,
                          dropdownIconPosition: IconPosition.trailing,
                          showCountryFlag: false,
                          disableLengthCheck: true,
                          initialCountryCode:
                              'US', // Set the initial country code if needed
                          onChanged: (phone) {
                            phoneNumber = phone.completeNumber;
                          },
                        ),
                        SizedBox(
                          height: getSizeHeight(context) * 0.03,
                        ),
                        getUserAuthProvider(context, true)
                                    .verifySignUpLoading ==
                                false
                            ? CustomButton(
                                buttonText: 'Submit',
                                bordercolor: Colors.transparent,
                                radius: 40,
                                onTap: () async {
                                  if (validateForm(
                                      formKey.currentState ?? FormState())) {
                                    final check = await getUserAuthProvider(
                                            context, false)
                                        .checkPhoneNumber(phoneNumber);
                                    if (check == true) {
                                      await getUserAuthProvider(context, false)
                                          .sendPasswordResetCode(
                                              context, phoneNumber, 2);
                                    } else {
                                      FlushBar.topFlushBarMessage(
                                          "User Not Found Please Sign Up",
                                          context,
                                          kRedColor,
                                          Icon(Icons.warning));
                                    }
                                  } else {
                                    // Form is invalid, show error message
                                  }
                                },
                                // onTap: () => Get.to(() => UOTPScreen()),
                              )
                            : CupertinoActivityIndicator(
                                radius: 20,
                                color: kPrimaryColor,
                              ),
                        SizedBox(
                          height: getSizeHeight(context) * 0.14,
                        ),
                        SizedBox(
                          height: getSizeHeight(context) * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
