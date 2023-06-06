import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';

Widget loadingWidget({
  double size = 30.0,
}) {
  return Center(
    child: SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(color: kblackColor),
    ),
  );
}
