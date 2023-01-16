import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hop_on/Utils/colors.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioInterceptior extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);

    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString("authToken");

    options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
    };

    if (authToken != null) {
      options.headers = <String, String>{"Authorization": authToken};
    }

    log("DioInterceptor.class: Dio Request: ${options.toString()}, ${options.data?.toString()}, ${options.uri}");
  }

  @override
  Future<String> onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);

    log("DioInterceptor.class: Error from dio request: ${err.toString()}, ${err.response?.data?.toString()}, ${err.message}, ${err.requestOptions.data.toString()}, ${err.requestOptions.uri.toString()}");

    if (err.response != null) {
      if (err.response!.data != null) {
        if (err.response!.data!
            .toString()
            .contains("SocketException: Failed host lookup")) {
          handler.reject(DioError(
              requestOptions:
                  RequestOptions(path: "", data: {"message": "no iNTERNET"})));
        }

        if (err.response!.data.toString().contains("INVALID_TOKEN")) {
          final prefs = await SharedPreferences.getInstance();

          final String? token = prefs.getString("authToken");

          Sentry.captureMessage("Logging out due to invalid token");
          log("Logging out due to invalid token");
        }
      }
    }

    return err.response?.data?.toString() ?? "";
  }
}
