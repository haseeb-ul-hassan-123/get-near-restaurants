import 'package:flutter/cupertino.dart';

bool validateForm(FormState form) {
  if (form.validate()) {
    form.save();
    return true;
  } else {
    return false;
  }
}
