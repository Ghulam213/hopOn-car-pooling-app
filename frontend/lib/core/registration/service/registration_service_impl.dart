import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/error.dart';
import '../../../Utils/helpers.dart';
import '../../../config/network/network_config.dart';
import '../domain/registartion_service.dart';
import '../models/driver_response.dart';

class RegistrationServiceImpl extends RegistrationService {
  final Dio dio = NetworkConfig().dio;

  @override
  Future<DriverInfoResponse> registerDriver(
      {String? userId,
      String? cnicFront,
      String? cnicBack,
      String? licenseFront,
      String? licenseBack,
      String? vehicleType,
      String? vehicleBrand,
      String? vehicleModel,
      String? vehicleColor,
      String? vehiclePhoto,
      String? vehicleRegImage}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final body = {
        "userId": id,
        "cnicFront": cnicFront,
        'cnicBack': cnicBack,
        "licenseFront": licenseFront,
        "licenseBack": licenseBack,
        "vehicle": {
          "vehicleType": 'CAR',
          "vehicleBrand": vehicleBrand,
          "vehicleModel": vehicleModel,
          "vehicleColor": vehicleColor,
          "vehiclePhoto": vehiclePhoto,
          "vehicleRegImage": vehicleRegImage,
        }
      };
      logger("BranchServiceImpl: registerDriver() Body: $body");

      final Response response = await dio.post('/driver',
          data: jsonEncode(body),
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));
          
      logger("BranchServiceImpl: registerDriver() Respose: $response.data");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse = DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        log(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> getDriver() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("driverId");

      final Response response =
          await dio.get('/driver/$id', queryParameters: {'id': id});
      debugPrint(response.data.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse = DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
     
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("driverID", driverResponse.data!.id!.toString());

        debugPrint("Getting Driver Details");
        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> updateDriverInfo(String? userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final Response response = await dio.get('/user/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse = DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        log(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("driverID", driverResponse.data!.id!.toString());

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }

  @override
  Future<DriverInfoResponse> searchDriver(String? userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final Response response = await dio.get('/user/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverInfoResponse driverResponse = DriverInfoResponse.fromJson(response.data as Map<String, dynamic>);
        log(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("driverID", driverResponse.data!.id!.toString());

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(e.response?.data as Map<String, dynamic>);
        } else {
          if (e.message.contains("SocketException: Failed host lookup")) {
            throw "No internet connection";
          }
        }
      }
      throw e.toString();
    }
  }
}
