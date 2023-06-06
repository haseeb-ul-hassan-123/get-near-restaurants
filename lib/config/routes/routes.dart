import 'package:flutter/cupertino.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/account_type.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_sign_up.dart';

import '../../views/screens/splash_screen/splash_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    AppLinks.splashScreen: (_) => SplashScreen(),
    AppLinks.accountType: (_) => AccountType(),
    AppLinks.usignup: (_) => USignUp(),
  };
}

class AppLinks {
  static const splashScreen = '/splash_screen';
  static const accountType = '/accountType';
  //*********User Side*************
  static const ulogin = '/ulogin';
  static const usignup = '/usignup';
}
