import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/validate.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/provider_setup.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/models/user/user_model.dart';
import 'package:hoyzee_app_map_feature/provider/user/auth_provider.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_forget_password.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_sign_up.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_textfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class ULogin extends StatefulWidget {
  const ULogin({Key? key}) : super(key: key);

  @override
  State<ULogin> createState() => _ULoginState();
}

class _ULoginState extends State<ULogin> {
  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String initialCountry = 'PK';

  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  String phoneNumber = '';

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    _passwordController.dispose();
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
        body: _buildLoginForm());
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        Center(
          child: CustomText(
            text: 'Welcome Back',
            size: 32,
            weight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: getSizeHeight(context) * 0.06,
        ),
        Expanded(
          child: Container(
            height: getCustomSize(context).height * 0.81,
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
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getSizeHeight(context) * 0.03,
                      ),
                      CustomText(
                        text: 'Sign in to get started',
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8),
                          child: CustomText(
                            text: 'Password',
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.015,
                      ),
                      Consumer<UserAuthProvider>(builder: (_, value, child) {
                        return CustomTextField(
                          marginBottom: 0,
                          hintText: 'Enter password',
                          controller: _passwordController,
                          icon: Assets.lock,
                          isObSecure: value.isLoginPasswordVisible,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                value.toggleLoginPasswordVisibility();
                              },
                              child: value.isLoginPasswordVisible == true
                                  ? Icon(
                                      size: 24,
                                      color: Colors.grey,
                                      CupertinoIcons.eye_slash)
                                  : Icon(
                                      CupertinoIcons.eye,
                                      size: 24,
                                      color: Colors.black,
                                    )),
                          formFieldValidator: (value) {
                            if (value.isEmpty) {
                              return "Please enter confirm password";
                            } else if (_passwordController.text != value) {
                              return "Confirm password not matched!";
                            }
                          },
                        );
                      }),
                      SizedBox(
                        height: getSizeHeight(context) * 0.025,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomText(
                            onTap: () => Get.to(() => UForgetPassword()),
                            text: "Forget Password?",
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      getUserAuthProvider(context, true).signInLoader == false
                          ? SizedBox(
                              height: getSizeHeight(context) * 0.04,
                            )
                          : SizedBox(
                              height: getSizeHeight(context) * 0.04,
                            ),
                      getUserAuthProvider(context, true).signInLoader == false
                          ? CustomButton(
                              buttonText: 'Sign In',
                              bordercolor: Colors.transparent,
                              radius: 40,
                              onTap: () async {
                                if (validateForm(
                                    formKey.currentState ?? FormState())) {
                                  final check =
                                      await getUserAuthProvider(context, false)
                                          .checkPhoneNumberAndPassword(
                                              context,
                                              phoneNumber,
                                              _passwordController.text);
                                  if (check == true) {
                                    await getUserAuthProvider(context, false)
                                        .signInUsingPhoneNumber(
                                            context,
                                            UserModel(
                                              password:
                                                  _passwordController.text,
                                              phoneNumber: phoneNumber,
                                              accountType: 0,
                                            ),
                                            1);
                                  } else {}
                                } else {
                                  // Form is invalid, show error message
                                }
                              })
                          : CupertinoActivityIndicator(
                              radius: 20,
                              color: kPrimaryColor,
                            ),
                      SizedBox(
                        height: getSizeHeight(context) * 0.14,
                      ),
                      getUserAuthProvider(context, true).signInLoader == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: "Don’t have an account? ",
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                CustomText(
                                  onTap: () => Get.to(() => USignUp()),
                                  text: "Sign Up",
                                  size: 14,
                                  weight: FontWeight.bold,
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: getSizeHeight(context) * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
