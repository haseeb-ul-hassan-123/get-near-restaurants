import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/flashbar.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/validate.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/provider_setup.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_dialog.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_textfield.dart';

class UNewPassword extends StatefulWidget {
  final PhoneAuthCredential credential;
  const UNewPassword({Key? key, required this.credential}) : super(key: key);

  @override
  State<UNewPassword> createState() => _UNewPasswordState();
}

class _UNewPasswordState extends State<UNewPassword> {
  @override
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  void dispose() {
    // TODO: implement dispose
    password.dispose();
    confirmPassword.dispose();
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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: CustomText(
                  text: 'New Password',
                  size: 32,
                  weight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getSizeHeight(context) * 0.06,
              ),
              Container(
                height: getCustomSize(context).height - 151.8,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getSizeHeight(context) * 0.03,
                      ),
                      CustomText(
                        text: 'Create a new password!',
                        size: 16,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.05,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CustomText(
                            text: 'New Password',
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.015,
                      ),
                      CustomTextField(
                        controller: password,
                        formFieldValidator: (value) {
                          if (value.isEmpty) {
                            return 'Enter password';
                          }
                          if (value.length != 8) {
                            return 'Enter more then eight character';
                          }
                        },
                        hintText: 'Enter new password',
                        icon: Assets.lock,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CustomText(
                            text: 'Confirm Password',
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.015,
                      ),
                      CustomTextField(
                        controller: confirmPassword,
                        formFieldValidator: (value) {
                          if (value.isEmpty) {
                            return 'Enter confirm password';
                          }
                          if (value != password.text) {
                            return 'Confirm password did not matched';
                          }
                          if (value.length != 8) {
                            return 'Enter more then eight character';
                          }
                        },
                        hintText: 'Enter confirm password',
                        icon: Assets.lock,
                      ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.05,
                      ),
                      loading == false
                          ? CustomButton(
                              buttonText: 'Submit',
                              bordercolor: Colors.transparent,
                              radius: 40,
                              onTap: () async {
                                if (validateForm(
                                    formKey.currentState ?? FormState())) {
                                  setState(() {
                                    loading = true;
                                  });
                                  final check =
                                      await getUserAuthProvider(context, false)
                                          .verificationDoneReset(
                                              widget.credential,
                                              context,
                                              password.text);
                                  setState(() {
                                    loading = false;
                                  });
                                  if (check == true) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return CustomDialog(
                                          image: Assets.lockImage,
                                          heading: 'Password Changed',
                                          content:
                                              'Your password have been successfully \nchanged!',
                                          onYesTap: () {
                                            getUserAuthProvider(context, false)
                                                .logout(context);
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    FlushBar.topFlushBarMessage(
                                        "Password Can not Change",
                                        context,
                                        kRedColor,
                                        Icon(Icons.warning));
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                } else {
                                  // Form is invalid, show error message
                                }
                              },
                            )
                          : Center(
                              child: CupertinoActivityIndicator(
                                radius: 20,
                                color: kPrimaryColor,
                              ),
                            ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
