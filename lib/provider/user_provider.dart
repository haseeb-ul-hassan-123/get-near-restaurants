import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool _isBlocked = false;

  bool get isBlocked => _isBlocked;

  listenToUser() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.get('isblocked') == true) {
        _isBlocked = true;
        notifyListeners();
      }
    });
  }
}
