import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/views/widgets/custom_text.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          text: 'Blocked',
          size: 14,
          weight: FontWeight.bold,
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 150,
          ),
          Center(
            child: CustomText(
              text: "Blocked by the admin",
              size: 22,
              weight: FontWeight.bold,
            ),
          ),
          Center(
            child: CustomText(
              text: "Contact to the admin ",
              size: 12,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
