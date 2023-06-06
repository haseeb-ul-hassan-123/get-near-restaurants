import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/provider/user/auth_provider.dart';
import 'package:hoyzee_app_map_feature/provider/user/edit_provider.dart';
import 'package:hoyzee_app_map_feature/provider/user/image_provider.dart';
import 'package:hoyzee_app_map_feature/provider/user/restaurants_provider.dart';
import 'package:hoyzee_app_map_feature/views/screens/splash_screen/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Map<int, Color> color = {
  50: Color(0xFFFFCA18).withOpacity(0.1),
  100: Color(0xFFFFCA18).withOpacity(0.2),
  200: Color(0xFFFFCA18).withOpacity(0.3),
  300: Color(0xFFFFCA18).withOpacity(0.4),
  400: Color(0xFFFFCA18).withOpacity(0.5),
  500: Color(0xFFFFCA18).withOpacity(0.6),
  600: Color(0xFFFFCA18).withOpacity(0.7),
  700: Color(0xFFFFCA18).withOpacity(0.8),
  800: Color(0xFFFFCA18).withOpacity(0.9),
  900: Color(0xFFFFCA18).withOpacity(1),
};
AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> checkNotificationPermission() async {
  final PermissionStatus status = await Permission.notification.status;
  if (status != PermissionStatus.granted) {
    final PermissionStatus permissionStatus =
        await Permission.notification.request();
    if (permissionStatus != PermissionStatus.granted) {
      // TODO: Handle notification permission denied.
    }
  }
}

main() async {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<UserAuthProvider>(
          create: (_) => UserAuthProvider()),
      ChangeNotifierProvider<ImageSelectProvider>(
          create: (_) => ImageSelectProvider()),
      ChangeNotifierProvider<EditableTextProvider>(
          create: (_) => EditableTextProvider()),
      ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider()),
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'hoyzee',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(0xFFFFCA18, color))
            .copyWith(background: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      home: SplashScreen(),
      defaultTransition: Transition.fade,
    );
  }
}
