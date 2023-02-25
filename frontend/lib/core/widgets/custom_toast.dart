import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void customToastWhite(String message, double fontSize, ToastGravity gravity) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: Colors.white,
    textColor: Colors.black54,
    fontSize: fontSize,
  );
}

void customToastBlack(
    {required String msg,
    double? fontSize = 15,
    ToastGravity? gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    timeInSecForIosWeb: 10,
    backgroundColor: Colors.black.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: fontSize,
  );
}
