// ignore_for_file: use_build_context_synchronously

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
import 'package:hop_on/core/map/screens/home.dart';
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
  bool isDriver = false;

  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  late String authToken = '';

  bool get isAuth {
    // getting token to see if user logged in or not
    return authToken != '';
  }

  // PHONE SIGN IN
  @action
  Future<void> phoneLogin(BuildContext context, String phone, String pass) async {
    final body = {"phone": phone, "password": pass};

    if (phone != '') {
      try {
        isPhoneLoading = true;
        final Response response = await dio.post(
          '/login',
          data: jsonEncode(body),
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );

        isPhoneLoading = false;

        if (response.statusCode == 200 || response.statusCode == 201) {
          isPhoneDone = true;
          await _storeUserData(response.data);
          Future.delayed(const Duration(milliseconds: 1), () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpPage(
                  phoneNumber: phone,
                  otpmode: 'login',
                ),
              ),
            );
          });
        } else {
   
          final String errorMsg = response.statusMessage as String;

          _showSnackBar(context, errorMsg);
          AppErrors.processErrorJson(response.data['data'] as Map<String, dynamic>);
        }
      } on DioError catch (e) {
        debugPrint("phoneLogin. $e");

        isPhoneLoading = false;
        if (e.response != null) {
          _showSnackBar(context, '${e.response!.data["message"]?.toString()}');
          log(e.response!.data.toString());
          AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          log(e.message);
        }
      }
    } else {
      _showSnackBar(
        context,
        tr("Please provide a phone number"),
      );
    }
  }

  // OTP VERIFICATION
  @action
  Future<void> validateOtpAndLogin(BuildContext context, String smsCode, String phone) async {
    final body = {"phone": phone, "code": smsCode};

    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post(
        '/verify-register',
        data: jsonEncode(body),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      isOtpLoading = false;
      final result = response.data['data'] as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data['data'].toString());
        await _storeUserData(response.data);
        isUserInfoLoading = false;
        onOtpSuccessful(context, result);

        //NOTE: This line only allows branch users to enter the Accept App
        // await limitEntry(response, context, result);
      } else {
        final String errorMsg = response.data['data']["message"] as String;
        _showSnackBar(context, errorMsg);
      }
    } on DioError catch (e) {
      log("validateOtpAndLogin. $e");
      isOtpLoading = false;

      if (e.response != null) {
        _showSnackBar(context, '${e.response!.data["message"]?.toString()}');
        log(e.response!.data.toString());
        AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(e.message);
      }
    }
  }

  // USER SIGNUP
  @action
  Future<void> registerUser(
    BuildContext context,
    String password,
    String phone,
    String email,
    String firstName,
    String lastName,
  ) async {
    log("registerUser");

    final prefs = await SharedPreferences.getInstance();
    final body = {
      "password": password,
      "phone": phone,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      // "currentCity": 'islmabad'
    };

    debugPrint(phone);
    debugPrint(password);

    try {
      isOtpLoading = true;
      isUserInfoLoading = true;
      final Response response = await dio.post(
        '/register',
        data: jsonEncode(body),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      isOtpLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        log(response.data['data'].toString());
        // await _storeUserData(response.data['data']);
        debugPrint(response.data['data']['id']);
        prefs.setString('userEmail', response.data['data']['email'] as String);
        prefs.setString('currentMode', response.data['data']['currentMode'] as String);
        prefs.setString('userID', response.data['data']['id'] as String);
        prefs.setString('userPhoneNo', response.data['data']['phoneNo'] as String);

        isUserInfoLoading = false;
        Future.delayed(const Duration(milliseconds: 1), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpPage(
                phoneNumber: phone,
                otpmode: 'signup',
              ),
            ),
          );
        });
        // onOtpSuccessful(context, result);
      } else {
        final String errorMsg = response.statusMessage as String;
        _showSnackBar(context, errorMsg);
      }
    } on DioError catch (e) {
      log("registerUser. $e");
      isOtpLoading = false;

      if (e.response != null) {
        _showSnackBar(context, '${e.response!.data["message"]?.toString()}');
        log(e.response!.data.toString());
        AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log(e.message);
      }
    }
  }

  Future<void> onOtpSuccessful(BuildContext context, Map<String, dynamic> response) async {
    isOtpDone = true;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MapScreen(),
      ),
      (Route<dynamic> route) => false,
    );
    isOtpLoading = false;
  }

  // saving user to Shared preferences
  Future<void> _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> userAuth = responseData['data'] as Map<String, dynamic>;

    prefs.setString('accessToken', userAuth['accessToken'] as String);
    prefs.setString('refreshToken', userAuth['refreshToken'] as String);
    prefs.setString('userID', userAuth['userId'] as String);
    prefs.setString('userMode', userAuth['user']['currentMode'] as String);
    prefs.setString("user", jsonEncode(userAuth['user']));

    if (userAuth['user']['currentMode'] == 'DRIVER') {
      isDriver = true;
      prefs.setString("driverID", userAuth['driverId'] as String);
    } else {
      isDriver = false;
      prefs.setString("passengerID", userAuth['passengerId'] as String);
    }
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

        throw AppErrors.processErrorJson(e.response!.data as Map<String, dynamic>);
      }
      {
        // Something happened in setting up or sending the request that triggered an Error
        log(e.message);
      }
    }
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}
