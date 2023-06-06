import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/ubottom_nav_bar.dart';

import '../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int? accountType;
  bool? isblocked;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void _getUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      print('IN.....');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) => ({
                setState(() {
                  accountType = value['accountType'];
                  isblocked = value['isblocked'];
                })
              }));
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _checkConnectivity();
    Future.delayed(Duration(seconds: 3), () async {
      if (accountType != null) {
        if (isblocked == false) {
          if (accountType == 0) {
            Get.offAll(UBottomNavBar());
          } else {
            if (accountType == 1) {
              if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
              } else {}
            }
          }
        } else {
          await FirebaseAuth.instance.signOut();
        }
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription?.cancel();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      _connectivitySubscription =
          Connectivity().onConnectivityChanged.listen((result) {
        if (result == ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No internet connection'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: CircleAvatar(
          backgroundColor: kblackColor,
          radius: 100,
          child: Image.asset(
            Assets.AppLogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
