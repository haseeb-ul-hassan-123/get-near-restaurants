// import 'package:flutter/material.dart';
// import 'package:hoyzee/models/user/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LocallyAuthProvider with ChangeNotifier {
//   UserModel? _user;
//
//   Future<void> loadUser() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final userId = prefs.getString('userId');
//     final firstName = prefs.getString('firstName');
//     final lastName = prefs.getString('lastName');
//     final password = prefs.getString('password');
//     final phoneNumber = prefs.getString('phoneNumber');
//     final accountType = prefs.getInt('accountType');
//     final latitude = prefs.getDouble('latitude');
//     final longitude = prefs.getDouble('longitude');
//     final address = prefs.getString('address');
//
//     _user = UserModel(
//       userId: userId,
//       firstName: firstName,
//       lastName: lastName,
//       password: password,
//       phoneNumber: phoneNumber,
//       accountType: accountType,
//       latitude: latitude,
//       longitude: longitude,
//       address: address,
//     );
//
//     notifyListeners();
//   }
//
//   bool get hasUser {
//     return _user != null;
//   }
//
//   Future<void> saveUser(UserModel userModel) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userId', userModel.userId ?? "");
//     await prefs.setString('firstName', userModel.firstName ?? "");
//     await prefs.setString('lastName', userModel.lastName ?? "");
//     await prefs.setString('password', userModel.password ?? "");
//     await prefs.setString('phoneNumber', userModel.phoneNumber ?? "");
//     await prefs.setInt('accountType', userModel.accountType ?? 0);
//     await prefs.setDouble('latitude', userModel.latitude ?? 1);
//     await prefs.setDouble('longitude', userModel.longitude ?? 0.0);
//     await prefs.setString('address', userModel.address ?? "");
//
//     _user = userModel;
//
//     notifyListeners();
//   }
//
//   UserModel get user => _user ?? UserModel();
// }
