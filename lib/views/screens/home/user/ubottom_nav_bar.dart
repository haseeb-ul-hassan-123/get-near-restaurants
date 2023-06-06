import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoyzee_app_map_feature/constant/size.dart';
import 'package:hoyzee_app_map_feature/provider/user_provider.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/home/home.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/like/like.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import '../../../../constant/color.dart';
import '../../../../generated/assets.dart';

class UBottomNavBar extends StatefulWidget {
  @override
  State<UBottomNavBar> createState() => _UBottomNavBarState();
}

class _UBottomNavBarState extends State<UBottomNavBar> {
  int currentIndex = 0;
  List<String> _selectedIcon = [
    Assets.chomeImage,
    Assets.cheartImage,
    Assets.cnotificationImage,
    Assets.csettingsImage,
  ];
  List<String> _unSelectedIcon = [
    Assets.homeImage,
    Assets.heartImage,
    Assets.notificationImage,
    Assets.settingsImage,
  ];
  List<String> itemsName = ['Home', 'Favourits', 'Notifications', 'Settings'];

  final List<Widget> screens = [Home(), Like(), SizedBox(), SizedBox()];
  void initState() {
    // TODO: implement initState
    Provider.of<UserProvider>(context, listen: false).listenToUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isBlocked = userProvider.isBlocked;
    if (isBlocked) {
      print("==============Blocked=====================");
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: CustomText(
                    text: 'No',
                    weight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: CustomText(
                    text: 'Yes',
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: kwhiteColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: BottomNavigationBar(
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: kblackColor,
              selectedLabelStyle: GoogleFonts.inter(
                color: Theme.of(context).primaryColor,
                fontSize: getTextSize(context) * 10,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: getTextSize(context) * 10,
                fontWeight: FontWeight.w400,
              ),
              items: List.generate(
                _selectedIcon.length,
                (index) {
                  return BottomNavigationBarItem(
                    icon: Image.asset(
                      _unSelectedIcon[index],
                      height: getSizeHeight(context) * 0.03,

                      //width: getSizeWidth(context) * 0.04,
                    ),
                    activeIcon: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          _selectedIcon[index],
                          height: getSizeHeight(context) * 0.03,

                          //width: getSizeWidth(context) * 0.04,
                        ),
                        Positioned(
                          top: -10,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                                height: 3, width: 60, color: kPrimaryColor),
                          ),
                        )
                      ],
                    ),
                    label: itemsName[index],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
