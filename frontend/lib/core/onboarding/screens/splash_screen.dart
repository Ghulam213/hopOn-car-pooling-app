import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/screens/phone_login.dart';
import '../widgets/splash_widget.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      // await AppLocalizations.of(context)!.load();
      startNavigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashWidget();
  }

  Future<void> startNavigation() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("authToken");

    // context.setLocale(Locale(context.locale.toString(), ''));

    // if (token == null) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PhoneAuthScreen()));
    // }
    // else {
    //  // navigate to home screen
    // }
  }
}
