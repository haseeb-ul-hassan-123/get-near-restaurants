import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_sign_up.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_button.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

import '../../../generated/assets.dart';

class AccountType extends StatefulWidget {
  const AccountType({Key? key}) : super(key: key);

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: getSizeHeight(context) * 0.06),
            child: Center(
              child: CustomText(
                text: 'Sign up as a...',
                size: 32,
                weight: FontWeight.w600,
              ),
            ),
          ),
          Spacer(),
          Container(
            height: getCustomSize(context).height * 0.81,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Image.asset(
                    Assets.busImage,
                    height: getSizeHeight(context) * 0.3,
                    width: getSizeWidth(context) * 0.8,
                  ),
                ),
                SizedBox(
                  height: getSizeHeight(context) * 0.15,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: CustomButton(
                      buttonText: 'User',
                      bordercolor: Colors.transparent,
                      radius: 40,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => USignUp()));
                      },
                    )),
                SizedBox(
                  height: getSizeHeight(context) * 0.03,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
