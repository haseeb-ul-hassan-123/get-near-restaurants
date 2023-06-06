//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
//
// class ChangePasswordProvider with ChangeNotifier {
//   bool _isPasswordChanged = false;
//   bool get isPasswordChanged => _isPasswordChanged;
//
//   Future<void> changePassword(
//       String oldPassword, String newPassword, String confirmPassword,String userId) async {
//     try {
//
//       final userDocRef =
//       FirebaseFirestore.instance.collection('users').doc(userId).get();
//       if (oldPassword ==  userDocRef.) {
//         await userCredential.user!.updatePassword(newPassword);
//         await userDocRef.update({'password': newPassword});
//         _isPasswordChanged = true;
//         notifyListeners();
//       } else {
//         throw Exception('Old password does not match');
//       }
//     } catch (error) {
//       throw Exception('Password change failed: $error');
//     }
//   }
// }
