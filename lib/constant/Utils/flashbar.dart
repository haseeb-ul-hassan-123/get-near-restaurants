import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class FlushBar {
  static void topFlushBarMessage(
      String message, context, bgColor, Icon icon) async {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // padding: const EdgeInsets.all(12),
        message: message,
        duration: const Duration(seconds: 6),
        borderRadius: BorderRadius.circular(5),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: bgColor,
        reverseAnimationCurve: Curves.bounceInOut,
        flushbarStyle: FlushbarStyle.FLOATING,
        positionOffset: 20,
        icon: icon,
      )..show(context),
    );
  }
}
