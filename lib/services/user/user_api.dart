import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserApi {
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference restaurants =
      FirebaseFirestore.instance.collection('restaurants');
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final String currentUser =
      FirebaseAuth.instance.currentUser?.uid ?? '';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> updateUser(
      String address, double lat, double long) async {
    try {
      await users.doc(currentUser).update({
        'address': address,
        'latitude': lat,
        'longitude': long,
      });
    } catch (e) {}
  }

  static Future<String?> getDeviceToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Request permission to receive notifications (required for iOS)
    await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false, // for iOS 12 and above
    );

    // Get the device token
    String? deviceToken;
    try {
      deviceToken = await _firebaseMessaging.getToken();
      print('Device Token: $deviceToken');
    } catch (e) {
      print('Error getting device token: $e');
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      // Update token on your server
    });

    return deviceToken;
  }
}
