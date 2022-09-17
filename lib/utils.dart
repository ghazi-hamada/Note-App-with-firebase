import 'package:flutter/material.dart';
  final messengerkey = GlobalKey<ScaffoldMessengerState>();

class Utils {

  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    messengerkey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
