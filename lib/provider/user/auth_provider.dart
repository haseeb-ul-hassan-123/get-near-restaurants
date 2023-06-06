import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoyzee_app_map_feature/constant/color.dart';
import 'package:hoyzee_app_map_feature/models/user/user_model.dart';
import 'package:hoyzee_app_map_feature/services/user/user_api.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/account_type.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_new_password.dart';
import 'package:hoyzee_app_map_feature/views/screens/auth/user/u_otp_screen.dart';
import 'package:hoyzee_app_map_feature/views/screens/home/user/ubottom_nav_bar.dart';
import 'package:hoyzee_app_map_feature/views/screens/location/location.dart';

import '../../constant/Utils/flashbar.dart';

class UserAuthProvider extends ChangeNotifier {
  UserModel userModel = UserModel();
  bool verifySignUpLoading = false;
  bool get signupLoader => verifySignUpLoading;
  bool verifySignInLoading = false;
  bool resendLoading = false;
  bool get signInLoader => verifySignInLoading;
  bool get isresendingLoading => resendLoading;
  setSignUpLoading(bool loading) {
    verifySignUpLoading = loading;
    notifyListeners();
  }

  setSignInLoading(bool loading) {
    verifySignInLoading = loading;
    notifyListeners();
  }
  //TODO: Register User using Phone Number

  setresendLoading(bool loading) {
    resendLoading = loading;
    notifyListeners();
  }

  String? verificationId;
  bool _isPasswordVisible = true;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  bool _isLoginPasswordVisible = true;

  bool get isLoginPasswordVisible => _isLoginPasswordVisible;

  void toggleLoginPasswordVisibility() {
    _isLoginPasswordVisible = !_isLoginPasswordVisible;
    notifyListeners();
  }

  Future<bool> checkPhoneNumberAndPassword(
      BuildContext context, String phoneNumber, String password) async {
    final QuerySnapshot result = await UserApi.users
        .where('phoneNumber', isEqualTo: phoneNumber)
        .where('password', isEqualTo: password)
        .get();
    setSignInLoading(true);
    print(result.docs.length);
    if (result.docs.isNotEmpty) {
      if (result.docs[0].get('isblocked') == false) {
        setSignInLoading(false);
        return true;
      } else {
        setSignInLoading(false);
        FlushBar.topFlushBarMessage(
            'User is blocked by the admin',
            context,
            kRedColor,
            Icon(
              Icons.warning,
              color: Colors.white,
              size: 28,
            ));
        return false;
      }
    } else {
      setSignInLoading(false);
      FlushBar.topFlushBarMessage("User Not Found Please Sign Up", context,
          kRedColor, Icon(Icons.warning));
      return false;
    }
  }

  Future<bool> checkPhoneNumberAndPasswordSignUp(
      BuildContext context, String phoneNumber, String password) async {
    final QuerySnapshot result = await UserApi.users
        .where('phoneNumber', isEqualTo: phoneNumber)
        .where('password', isEqualTo: password)
        .get();
    setSignInLoading(true);
    print(result.docs.length);
    if (result.docs.isNotEmpty) {
      setSignInLoading(false);
      return true;
    } else {
      setSignInLoading(false);
      return false;
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    final QuerySnapshot result =
        await UserApi.users.where('phoneNumber', isEqualTo: phoneNumber).get();
    setSignInLoading(true);
    print(result.docs.length);
    if (result.docs.isNotEmpty) {
      setSignInLoading(false);
      return true;
    } else {
      setSignInLoading(false);
      return false;
    }
  }

  Future<void> signUpToUsingPhoneNumber(
      BuildContext context, UserModel userModel, int type) async {
    try {
      print("try");
      setSignUpLoading(true);
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: userModel.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          verificationDoneSignUp(credential, context, userModel);
        },
        verificationFailed: (FirebaseAuthException e) {
          setSignUpLoading(false);
          FlushBar.topFlushBarMessage(
              e.toString(),
              context,
              kRedColor,
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 28,
              ));

          if (e.code == 'invalid-phone-number') {
            setSignUpLoading(false);
            FlushBar.topFlushBarMessage(
                "The provided phone number is not valid",
                context,
                kRedColor,
                Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 28,
                ));
          }
        },
        codeSent: (String? verificationId, int? resendToken) {
          setSignUpLoading(false);
          this.verificationId = verificationId;
          setSignUpLoading(false);
          Get.to(UOTPScreen(
            userModel: userModel,
            logintype: type,
          ));
          setSignUpLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
      print('dsd');
    } catch (e) {
      setSignUpLoading(false);
      FlushBar.topFlushBarMessage(
          e.toString(),
          context,
          kRedColor,
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 28,
          ));
    }
  }

  Future<void> signInUsingPhoneNumber(
      BuildContext context, UserModel userModel, int type) async {
    try {
      print("try");
      setSignInLoading(true);
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: userModel.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          verificationDoneLogin(credential, context, userModel);
        },
        verificationFailed: (FirebaseAuthException e) {
          setSignInLoading(false);
          FlushBar.topFlushBarMessage(
              e.toString(),
              context,
              kRedColor,
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 28,
              ));

          if (e.code == 'invalid-phone-number') {
            setSignInLoading(false);
            debugPrint('The provided phone number is not valid.');
            FlushBar.topFlushBarMessage(
                "The provided phone number is not valid",
                context,
                kRedColor,
                Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 28,
                ));
          }
        },
        codeSent: (String? verificationId, int? resendToken) {
          setSignInLoading(false);
          this.verificationId = verificationId;
          Navigator.popUntil(context, (route) => route.isFirst);
          setSignInLoading(false);
          Get.to(UOTPScreen(
            userModel: userModel,
            logintype: type,
          ));
          setSignInLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
      print('dsd');
    } catch (e) {
      setSignInLoading(false);
      FlushBar.topFlushBarMessage(
          e.toString(),
          context,
          kRedColor,
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 28,
          ));
    }
  }

  String? firstName;
  String? lastName;
  String? phoneNumber;
  Future<void> getUserData(String userId) async {
    final userData = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      firstName = value['firstName'];
      lastName = value['lastName'];
      phoneNumber = value['phoneNumber'];
      notifyListeners();
    });
  }

  Future<void> Resend(
    phoneNumber,
    BuildContext context,
  ) async {
    try {
      setresendLoading(true);
      UserApi.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
            FlushBar.topFlushBarMessage(
                "The provided phone number is not valid",
                context,
                kPrimaryColor,
                Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 28,
                ));
          }
        },
        codeSent: (String? verificationId, int? resendToken) {
          FlushBar.topFlushBarMessage(
              "Code Sent successfully",
              context,
              Colors.green,
              Icon(
                Icons.check,
                color: Colors.white,
                size: 28,
              ));
          setresendLoading(false);
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          setresendLoading(true);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setresendLoading(true);
      FlushBar.topFlushBarMessage(
          e.toString(),
          context,
          kPrimaryColor,
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 28,
          ));
    }
  }

  Future<void> sendPasswordResetCode(
      BuildContext context, String phoneNumber, int type) async {
    setSignUpLoading(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UNewPassword(
                      credential: credential,
                    )));
      },
      verificationFailed: (FirebaseAuthException e) {
        setSignUpLoading(false);
        FlushBar.topFlushBarMessage(
            e.toString(),
            context,
            kRedColor,
            Icon(
              Icons.warning,
              color: Colors.white,
              size: 28,
            ));

        if (e.code == 'invalid-phone-number') {
          setSignUpLoading(false);
          debugPrint('The provided phone number is not valid.');
          FlushBar.topFlushBarMessage(
              "The provided phone number is not valid",
              context,
              kRedColor,
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 28,
              ));
        }
      },
      codeSent: (String? verificationId, int? resendToken) {
        setSignUpLoading(false);
        this.verificationId = verificationId;
        Navigator.popUntil(context, (route) => route.isFirst);
        setSignUpLoading(false);
        Get.to(UOTPScreen(
          userModel: userModel,
          logintype: type,
        ));
        setSignUpLoading(false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<bool> verifyOtpForSignUp(smsCode, context, UserModel userModel) async {
    try {
      setSignUpLoading(true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      verificationDoneSignUp(credential, context, userModel);
      setSignUpLoading(false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOtpForReset(
    smsCode,
    context,
  ) async {
    try {
      setSignUpLoading(true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UNewPassword(
                    credential: credential,
                  )));
      setSignUpLoading(false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> verificationDoneSignUp(
      PhoneAuthCredential credential, context, UserModel userModel) async {
    try {
      setSignUpLoading(true);
      UserCredential userCredential =
          await UserApi.auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        setSignUpLoading(true);

        await UserApi.users.doc(FirebaseAuth.instance.currentUser?.uid).set(
            UserModel(
                    userId: userCredential.user?.uid,
                    firstName: userModel.firstName,
                    lastName: userModel.lastName,
                    password: userModel.password,
                    phoneNumber: userModel.phoneNumber,
                    accountType: userModel.accountType,
                    latitude: userModel.latitude,
                    longitude: userModel.longitude,
                    address: userModel.address)
                .toJson());
        String? deviceToken = await UserApi.getDeviceToken();
        if (deviceToken!.isNotEmpty) {
          await UserApi.users
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .update({
            'deviceToken': deviceToken,
            'isblocked': false,
          });
        }
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomLocation(type: userModel.accountType ?? 0)));
        setSignUpLoading(false);
      }
    } on FirebaseAuthException catch (e) {
      setSignUpLoading(false);
      FlushBar.topFlushBarMessage(
          "${e.message}",
          context,
          kRedColor,
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 28,
          ));
      debugPrint(e.message.toString());
    }
  }

  Future<bool> verifyOtpForSignIn(smsCode, context, UserModel userModel) async {
    try {
      setSignInLoading(true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      verificationDoneLogin(credential, context, userModel);
      setSignInLoading(false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verificationDoneReset(
      PhoneAuthCredential credential, context, String password) async {
    try {
      setSignUpLoading(true);
      UserCredential userCredential =
          await UserApi.auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        setSignUpLoading(true);
        await UserApi.users.doc(FirebaseAuth.instance.currentUser?.uid).update({
          'password': password,
        });
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AccountType()));
        setSignUpLoading(false);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      setSignUpLoading(false);
      FlushBar.topFlushBarMessage(
          "${e.message}",
          context,
          kRedColor,
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 28,
          ));
      debugPrint(e.message.toString());
      return false;
    }
  }

  Future<void> verificationDoneLogin(
      PhoneAuthCredential credential, context, UserModel userModel) async {
    try {
      setSignInLoading(true);
      UserCredential userCredential =
          await UserApi.auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        setSignInLoading(true);
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UBottomNavBar()));
        setSignInLoading(false);
      }
    } on FirebaseAuthException catch (e) {
      setSignInLoading(false);
      FlushBar.topFlushBarMessage(
          "${e.message}",
          context,
          kRedColor,
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 28,
          ));
      debugPrint(e.message.toString());
    }
  }

  void logout(context) {
    UserApi.auth.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AccountType()));
      notifyListeners();
    });
  }
}
