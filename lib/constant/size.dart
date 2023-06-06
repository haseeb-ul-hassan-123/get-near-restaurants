import 'package:flutter/cupertino.dart';

double getSizeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Size getCustomSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double getSizeWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getTextSize(BuildContext context) {
  return MediaQuery.textScaleFactorOf(context);
}
