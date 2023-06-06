import 'package:flutter/cupertino.dart';

class EditableTextProvider extends ChangeNotifier {
  bool isEditingProfile = true;
  void Editing() {
    isEditingProfile = !isEditingProfile;
    notifyListeners();
  }
}
