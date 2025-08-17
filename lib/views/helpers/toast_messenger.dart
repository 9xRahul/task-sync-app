import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastHelper {
  static void show(
    String message, {
    Color bgColor = Colors.red,
    Color textColor = Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: message,

      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
