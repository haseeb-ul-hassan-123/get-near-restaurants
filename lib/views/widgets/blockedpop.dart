import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/auth/account_type.dart';

void showBlockedUserPopUp(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Blocked'),
        content: Text('You have been blocked by the Admin'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) => {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AccountType()))
                  });
            },
          ),
        ],
      );
    },
  );
}
