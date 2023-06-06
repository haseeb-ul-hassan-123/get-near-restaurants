import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/flashbar.dart';
import 'package:hoyzee_app_map_feature/constant/provider_setup.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/models/user/user_model.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../../../constant/color.dart';

class UOTPScreen extends StatefulWidget {
  final UserModel userModel;
  final int logintype;
  UOTPScreen({Key? key, required this.userModel, required this.logintype})
      : super(key: key);

  @override
  State<UOTPScreen> createState() => _UOTPScreenState();
}

class _UOTPScreenState extends State<UOTPScreen> {
  @override
  TextEditingController _otpController = TextEditingController(text: "");
  @override
  void dispose() {
    // TODO: implement dispose
    _otpController.dispose();
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
        body: _buildOTPForm());
  }

  Widget _buildOTPForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: CustomText(
              text: 'Verify Your Phone Number',
              size: 24,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: getSizeHeight(context) * 0.06,
          ),
          Container(
            height: getCustomSize(context).height - 141.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getSizeHeight(context) * 0.07,
                    ),
                    CustomText(
                      text: 'Enter the OTP code from the phone',
                      size: 16,
                      weight: FontWeight.w400,
                    ),
                    CustomText(
                      text: 'number we just sent you',
                      size: 16,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: getSizeHeight(context) * 0.09,
                    ),
                    PinCodeTextField(
                      controller: _otpController,
                      pinBoxWidth: 40,
                      pinBoxHeight: 40,
                      pinTextStyle: TextStyle(
                          color: kblackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      maxLength: 6,
                      pinBoxBorderWidth: 1,
                      pinBoxRadius: 8,
                      highlightColor: Colors.black,
                      pinTextAnimatedSwitcherTransition:
                          ProvidedPinBoxTextAnimation.scalingTransition,
                      defaultBorderColor: Colors.grey,
                      wrapAlignment: WrapAlignment.spaceBetween,
                    ),
                    getUserAuthProvider(context, true).signInLoader == false
                        ? SizedBox(
                            height: getSizeHeight(context) * 0.05,
                          )
                        : SizedBox(
                            height: getSizeHeight(context) * 0.1,
                          ),
                    getUserAuthProvider(context, true).signInLoader == false
                        ? CustomButton(
                            buttonText: 'Submit',
                            bordercolor: Colors.transparent,
                            radius: 40,
                            onTap: () async {
                              if (widget.logintype == 0) {
                                if (_otpController.text.length == 6) {
                                  final result =
                                      await getUserAuthProvider(context, false)
                                          .verifyOtpForSignUp(
                                              _otpController.text,
                                              context,
                                              widget.userModel);
                                  if (result == true) {
                                  } else {
                                    FlushBar.topFlushBarMessage(
                                        "Something went wrong!",
                                        context,
                                        kRedColor,
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                          size: 28,
                                        ));
                                  }
                                } else {
                                  FlushBar.topFlushBarMessage(
                                      "SMS Code Field can't be empty",
                                      context,
                                      kRedColor,
                                      Icon(
                                        Icons.warning,
                                        color: kwhiteColor,
                                        size: 28,
                                      ));
                                }
                              } else if (widget.logintype == 1) {
                                if (_otpController.text.length == 6) {
                                  final result =
                                      await getUserAuthProvider(context, false)
                                          .verifyOtpForSignIn(
                                              _otpController.text,
                                              context,
                                              widget.userModel);
                                  if (result == true) {
                                  } else {
                                    FlushBar.topFlushBarMessage(
                                        "Something went wrong!",
                                        context,
                                        kRedColor,
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                          size: 28,
                                        ));
                                  }
                                } else {
                                  FlushBar.topFlushBarMessage(
                                      "SMS Code Field can't be empty",
                                      context,
                                      kRedColor,
                                      Icon(
                                        Icons.warning,
                                        color: kwhiteColor,
                                        size: 28,
                                      ));
                                }
                              } else {
                                if (_otpController.text.length == 6) {
                                  final result =
                                      await getUserAuthProvider(context, false)
                                          .verifyOtpForReset(
                                              _otpController.text, context);
                                  if (result == true) {
                                  } else {
                                    FlushBar.topFlushBarMessage(
                                        "Something went wrong!",
                                        context,
                                        kRedColor,
                                        Icon(
                                          Icons.warning,
                                          color: Colors.white,
                                          size: 28,
                                        ));
                                  }
                                } else {
                                  FlushBar.topFlushBarMessage(
                                      "SMS Code Field can't be empty",
                                      context,
                                      kRedColor,
                                      Icon(
                                        Icons.warning,
                                        color: kwhiteColor,
                                        size: 28,
                                      ));
                                }
                              }
                            },
                          )
                        : CupertinoActivityIndicator(
                            radius: 20,
                            color: kPrimaryColor,
                          ),
                    SizedBox(
                      height: getSizeHeight(context) * 0.06,
                    ),
                    getUserAuthProvider(context, true).resendLoading == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'Didn’t received code?',
                                size: 16,
                                weight: FontWeight.w400,
                              ),
                              InkWell(
                                onTap: () {
                                  getUserAuthProvider(context, false).Resend(
                                      widget.userModel.phoneNumber, context);
                                },
                                child: CustomText(
                                  text: ' Resend',
                                  size: 14,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : CupertinoActivityIndicator(
                            radius: 20,
                            color: Colors.black,
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
