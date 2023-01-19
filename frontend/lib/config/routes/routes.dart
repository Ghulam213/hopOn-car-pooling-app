import 'package:flutter/material.dart';
import 'package:hop_on/core/auth/screens/otp_screen.dart';
import 'package:hop_on/core/auth/screens/phone_login.dart';

mixin RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //Todo: Change when home screen is created

      case PhoneAuthScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => PhoneAuthScreen(),
        );
      case OtpPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const OtpPage(),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text('No route defined')),
      );
    });
  }
}
