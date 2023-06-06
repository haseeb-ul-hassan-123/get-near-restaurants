import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/flashbar.dart';
import 'package:hoyzee_app_map_feature/constant/Utils/validate.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/provider_setup.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/generated/assets.dart';
import 'package:hoyzee_app_map_feature/models/user/user_model.dart';
import 'package:hoyzee_app_map_feature/provider/user/auth_provider.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_login.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_textfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart';

class USignUp extends StatefulWidget {
  const USignUp({Key? key}) : super(key: key);

  @override
  State<USignUp> createState() => _USignUpState();
}

class _USignUpState extends State<USignUp> {
  @override
  bool _agreeToTerms = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'PK';
  var _signUpformKey = GlobalKey<FormState>();
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  String phoneNumber = '';
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    controller.dispose();
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
      body: Column(
        children: [
          Center(
            child: CustomText(
              text: 'Create Account',
              size: 28,
              weight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: getSizeHeight(context) * 0.06,
          ),
          _buildUSignUpForm(),
        ],
      ),
    );
  }

  String _selectedCountryCode = '+1';

  Widget _buildUSignUpForm() {
    return Expanded(
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
              key: _signUpformKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getSizeHeight(context) * 0.03,
                  ),
                  CustomText(
                    text: 'Sign up to get started',
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
                        text: 'First Name',
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getSizeHeight(context) * 0.015,
                  ),
                  CustomTextField(
                    controller: _firstNameController,
                    hintText: 'Enter your first name',
                    icon: Assets.profile,
                    formFieldValidator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter first name";
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: CustomText(
                        text: 'Last Name',
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getSizeHeight(context) * 0.015,
                  ),
                  CustomTextField(
                    hintText: 'Enter your last name',
                    controller: _lastNameController,
                    icon: Assets.profile,
                    formFieldValidator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter last name";
                      }
                    },
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
                    height: getSizeHeight(context) * 0.015,
                  ),
                  // TextFormField(
                  //   controller: TextEditingController(),
                  //   decoration: InputDecoration(
                  //     labelText: 'Phone Number',
                  //   ),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please enter a phone number';
                  //     }
                  //     return null;
                  //   },
                  //   keyboardType: TextInputType.phone,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.digitsOnly,
                  //   ],
                  // ),

                  // CustomTextField(
                  //   hintText: 'Enter your phone number',
                  //   icon: Assets.phone,
                  // ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
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
                      hintText: 'Enter password',
                      suffixIcon: GestureDetector(
                          onTap: () {
                            value.togglePasswordVisibility();
                          },
                          child: value.isPasswordVisible == true
                              ? Icon(
                                  size: 24,
                                  color: Colors.grey,
                                  CupertinoIcons.eye_slash)
                              : Icon(
                                  CupertinoIcons.eye,
                                  size: 24,
                                  color: Colors.black,
                                )),
                      isObSecure: value.isPasswordVisible,
                      formFieldValidator: (value) {
                        if (value.isEmpty) {
                          return "please enter password";
                        }
                        if (value.length < 8) {
                          return "Password is too short";
                        }
                        return null;
                      },
                      controller: _passwordController,
                      icon: Assets.lock,
                    );
                  }),
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
                  Consumer<UserAuthProvider>(builder: (_, value, child) {
                    return CustomTextField(
                      marginBottom: 0,
                      hintText: 'Enter confirm password',
                      controller: _confirmPasswordController,
                      icon: Assets.lock,
                      isObSecure: value.isPasswordVisible,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            value.togglePasswordVisibility();
                          },
                          child: value.isPasswordVisible == true
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
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.white,
                        checkColor: kPrimaryColor,
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  getUserAuthProvider(context, true).verifySignUpLoading ==
                          false
                      ? SizedBox(
                          height: getSizeHeight(context) * 0.02,
                        )
                      : SizedBox(
                          height: getSizeHeight(context) * 0.06,
                        ),
                  getUserAuthProvider(context, true).verifySignUpLoading ==
                          false
                      ? CustomButton(
                          buttonText: 'Sign Up',
                          bordercolor: Colors.transparent,
                          radius: 40,
                          onTap: () async {
                            print("Number${number.phoneNumber?.trim()}");
                            print(
                                "COntrollNumber${_phoneNumberController.text}");
                            if (validateForm(
                                _signUpformKey.currentState ?? FormState())) {
                              if (_agreeToTerms == true) {
                                final userExist =
                                    await getUserAuthProvider(context, false)
                                        .checkPhoneNumberAndPasswordSignUp(
                                            context,
                                            phoneNumber,
                                            _passwordController.text);
                                if (userExist == true) {
                                  FlushBar.topFlushBarMessage(
                                      "Account already Created please sign in",
                                      context,
                                      kRedColor,
                                      Icon(Icons.warning));
                                } else {
                                  await getUserAuthProvider(context, false)
                                      .signUpToUsingPhoneNumber(
                                          context,
                                          UserModel(
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            password: _passwordController.text,
                                            phoneNumber: phoneNumber,
                                            accountType: 0,
                                            address: '',
                                            latitude: 0.0,
                                            longitude: 0.0,
                                          ),
                                          0);
                                }
                              } else {
                                FlushBar.topFlushBarMessage(
                                    "Please Accept terms and conditions",
                                    context,
                                    kRedColor,
                                    Icon(Icons.warning));
                              }
                            } else {
                              // Form is invalid, show error message
                            }
                          },
                        )
                      : CupertinoActivityIndicator(
                          color: kPrimaryColor,
                          radius: 20,
                        ),
                  SizedBox(
                    height: getSizeHeight(context) * 0.04,
                  ),
                  getUserAuthProvider(context, true).verifySignUpLoading ==
                          false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Already have an account? ",
                              size: 14,
                              weight: FontWeight.w400,
                            ),
                            CustomText(
                              onTap: () => Get.to(() => ULogin()),
                              text: "Sign In",
                              size: 14,
                              weight: FontWeight.w600,
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
    );
  }
}
