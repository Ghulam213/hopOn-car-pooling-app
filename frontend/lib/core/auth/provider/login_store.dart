import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/Utils/error.dart';
import 'package:hop_on/config/network/network_config.dart';
import 'package:hop_on/core/auth/screens/otp_screen.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  String actualCode = '';

  final Dio dio = NetworkConfig().dio;

  @observable
  bool isPhoneLoading = false;
  @observable
  bool isEmailLoading = false;

  @observable
  late bool isOtpLoading = false;

  @observable
  late bool isUserInfoLoading = false;

  @observable
  late bool isPhoneDone = false;

  @observable
  late bool isEmailDone = false;

  @observable
  late bool isOtpDone = false;

  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  late String authToken = '';

  bool get isAuth {
    // getting token to see if user logged in or not
    return authToken != '';
  }

  // PHONE AUTH
  @action
  Future<void> phoneLogin(
      BuildContext context, String phone, String? appSig) async {
    log(phone);

    final body = {"phone": phone, "tfa": "false", "appsignature": appSig};

    if (phone != '') {
      try {
        isPhoneLoading = true;
        final Response response = await dio.post('auth/login',
            data: jsonEncode(body),
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }));

        final responseData = response.data as Map<String, dynamic>;
        isPhoneLoading = false;

        if (response.statusCode == 200) {
          isPhoneDone = true;

          Future.delayed(const Duration(milliseconds: 1), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) =>
                      OtpPage(
                        phoneNumber: phone,
                        otpmode: 'login',
                      )),
            );
          });
        } else {
          final String errorMsg = responseData["message"] as String;

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.white,
            content: Text(errorMsg,
                style: const TextStyle(color: Colors.red, fontSize: 15.0)),
          ));
          throw AppErrors.processErrorJson(
              response.data as Map<String, dynamic>);
        }
      } on DioError catch (e) {
        log("phoneLogin. $e");
        log('${e.error}');
        isPhoneLoading = false;
        if (e.response != null) {
          _showSnackBar(context, '${e.response!.data["message"]?.toString()}');
          log(e.response!.data.toString());
          throw AppErrors.processErrorJson(
              e.response!.data as Map<String, dynamic>);
        } else {
          // Something happened in setting up or sending the request that triggered an Error

          log(e.message);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.white,
        content: Text(tr("Please provide a phone number"),
            style: const TextStyle(color: Colors.red, fontSize: 15.0)),
      ));
    }
  }

  // OTP VERIFICATION
  @action
  Future<void> validateOtpAndLogin(
      BuildContext context, String smsCode, String phone) async {
    log("validateOtpAndLogin");
    log(phone);
    log(smsCode);

    final body = {"phone": phone, "tfa": "false", 'verification_code': smsCode};

    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post('auth/verify',
          data: jsonEncode(body),
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      isOtpLoading = false;
      final result = response.data as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
        await _storeUserData(response.data);

        isUserInfoLoading = false;

        onOtpSuccessful(context, result);

        //NOTE: This line only allows branch users to enter the Accept App
        await limitEntry(response, context, result);
      } else {
        final String errorMsg = response.data["message"] as String;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.white,
          content: Text(errorMsg,
              style: const TextStyle(color: Colors.red, fontSize: 15.0)),
        ));
      }
    } on DioError catch (e) {
      log("validateOtpAndLogin. $e");
      isOtpLoading = false;

      if (e.response != null) {
        _showSnackBar(context, '${e.response!.data["message"]?.toString()}');
        log(e.response!.data.toString());
        throw AppErrors.processErrorJson(
            e.response!.data as Map<String, dynamic>);
      } else {
        // Something happened in setting up or sending the request that triggered an Error

        log(e.message);
      }
    }
  }

  // EMAIL OTP
  // OTP VERIFICATION
  @action
  Future<void> validateEmailAndLogin(
      BuildContext context, String smsCode, String email) async {
    log("validateEmailOtpAndLogin");
    log(email);
    log(smsCode);

    final body = {"email": email, "tfa": "false", 'verification_code': smsCode};

    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post('auth/verify',
          data: jsonEncode(body),
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      isOtpLoading = false;
      final result = response.data as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data.toString());
        await _storeUserData(response.data);

        isUserInfoLoading = false;
        onOtpSuccessful(context, result);

        //NOTE: This line only allows branch users to enter the Accept App
        await limitEntry(response, context, result);
      } else {
        final String errorMsg = response.data["message"] as String;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.white,
          content: Text(errorMsg,
              style: const TextStyle(color: Colors.red, fontSize: 15.0)),
        ));
      }
    } on DioError catch (e) {
      log("validateEmailAndLogin. $e");
      isOtpLoading = false;

      if (e.response != null) {
        _showSnackBar(context, '${e.response!.data["message"]?.toString()}');
        log(e.response!.data.toString());
        throw AppErrors.processErrorJson(
            e.response!.data as Map<String, dynamic>);
      } else {
        // Something happened in setting up or sending the request that triggered an Error

        log(e.message);
      }
    }
  }

  Future<void> limitEntry(Response<dynamic> response, BuildContext context,
      Map<String, dynamic> result) async {
    if (response.data['data']['user_type'] == 'BusinessBranchUser' ||
        response.data['data']['user_type'] == 'BusinessDispatchUser') {
      log(response.data.toString());
      await _storeUserData(response.data);

      onOtpSuccessful(context, result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 5),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.white,
        content: Text(
            'The App is not supported to be used with this user type.\nالتطبيق لا يعمل على هذا النوع من الحساب بالوقت الحالي.',
            style: TextStyle(color: Colors.red, fontSize: 15.0)),
      ));
    }
  }

  Future<void> onOtpSuccessful(
      BuildContext context, Map<String, dynamic> response) async {
    isOtpDone = true;

    final Map<String, dynamic> result = response;

    final locale = result["data"]["locale"] as String;
    log(locale);

    context.setLocale(Locale(locale, ''));
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (_) => const OrderHomeScreen()),
    //     (Route<dynamic> route) => false);

    isOtpLoading = false;
  }

  // saving user to Shared preferences
  Future<void> _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> userAuth =
        responseData['data'] as Map<String, dynamic>;

    final String authToken = userAuth['auth_token'] as String;
    final String userName = (userAuth['user']['name'] ?? '') as String;
    final String userType = userAuth['user_type'] as String;
    final int userID = userAuth['user_id'] as int;
    final String userContact = (userAuth['email'] ?? '') as String;
    final int userAuthID = userAuth['id'] as int;

    prefs.setString('userAuthID', json.encode(userAuthID));
    prefs.setString('user', json.encode(userAuth));
    prefs.setString('authToken', authToken);
    prefs.setString('userName', userName);
    prefs.setString('userType', userType);
    prefs.setString('userID', userID.toString());
    prefs.setString('userContact', userContact);
    if (userType == 'BusinessBranchUser') {
      final int branchID = userAuth['user']['business_branch_id'] as int;
      prefs.setString('branchID', branchID.toString());
      log('--- in login store branchID = $branchID');
    }
    log(prefs.getString('userAuthID').toString());
    log(prefs.getString('user').toString());
    log(prefs.getString('authToken').toString());
    log(prefs.getString('userName').toString());
    log("user type${prefs.getString('userType')}");
    log(prefs.getString('userID').toString());
    log(prefs.getString('userContact').toString());
  }

  // logging out user
  Future<void> logoutUser(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await FirebaseMessaging.instance.deleteToken();

      await prefs.clear();
    } on DioError catch (e) {
      if (e.response != null) {
        _showSnackBar(context, "error while logging out");

        throw AppErrors.processErrorJson(
            e.response!.data as Map<String, dynamic>);
      }
      {
        // Something happened in setting up or sending the request that triggered an Error

        log(e.message);
      }
    }
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/');
  }

  // sending user selected locale language
  Future<void> sendUserLanguage(
    BuildContext context,
    String locale,
  ) async {
    log("Locale language: $locale");

    final body = {
      "locale": locale,
    };

    try {
      final Response response = await dio.put(
        '/locales?locale=$locale',
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
      } else {
        final String errorMsg = response.data["message"] as String;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.white,
          content: Text(errorMsg,
              style: const TextStyle(color: Colors.red, fontSize: 15.0)),
        ));
      }
    } on DioError catch (e) {
      if (e.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.white,
          content: Text(e.response!.data["message"]!.toString(),
              style: const TextStyle(color: Colors.red, fontSize: 15.0)),
        ));

        throw AppErrors.processErrorJson(
            e.response!.data as Map<String, dynamic>);
      } else {
        // Something happened in setting up or sending the request that triggered an Error

        log(e.message);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.white,
        content: Text(message,
            style: const TextStyle(color: Colors.red, fontSize: 15.0))));
  }
}
