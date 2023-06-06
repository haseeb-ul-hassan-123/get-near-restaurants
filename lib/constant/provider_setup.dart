import 'package:flutter/material.dart';
import 'package:hoyzee_app_map_feature/provider/user/auth_provider.dart';
import 'package:hoyzee_app_map_feature/provider/user/edit_provider.dart';
import 'package:hoyzee_app_map_feature/provider/user/image_provider.dart';
import 'package:provider/provider.dart';

//************************For User Provider*************************
UserAuthProvider getUserAuthProvider(BuildContext context, bool? listen) {
  return Provider.of<UserAuthProvider>(context, listen: listen ?? true);
}

ImageSelectProvider getImageProvider(BuildContext context, bool? listen) {
  return Provider.of<ImageSelectProvider>(context, listen: listen ?? true);
}

EditableTextProvider getEditableText(BuildContext context, bool? listen) {
  return Provider.of<EditableTextProvider>(context, listen: listen ?? true);
}
