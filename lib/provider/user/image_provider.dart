import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectProvider with ChangeNotifier {
  File? _image;

  File? get image => _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false;
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> takePicture() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<String?> uploadImage(String folderName, String imageName) async {
    try {
      _isLoading = true;
      notifyListeners();

      final ref = _storage.ref().child(folderName).child(imageName);
      final uploadTask = ref.putFile(image!);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _isLoading = false;
      notifyListeners();
      return downloadUrl;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }
}
