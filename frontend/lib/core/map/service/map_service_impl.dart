import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/core/map/domain/map_service.dart';
import 'package:hop_on/core/registration/models/driver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/error.dart';
import '../../../config/network/network_config.dart';
import '../models/map_response.dart';

class MapServiceImpl extends MapService {
  final Dio dio = NetworkConfig().dio;

  @override
  Future<MapResponse> findRides({
    String? source,
    String? destination,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? city = prefs.getString("currentCity");

      final body = {
        "source": source,
        'destination': destination,
        "city": city ?? 'Islamabad',
      };

      debugPrint(body.toString());
      debugPrint('/ride-for-passenger');

      final Response response =
          await dio.get('/ride-for-passenger', queryParameters: body);

      debugPrint(response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final MapResponse driverResponse =
            MapResponse.fromJson(response.data as Map<String, dynamic>);
        debugPrint(response.data.toString());

        debugPrint("Requesting for Rides ");
        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
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
  Future<MapResponse> requestRide({
    String? rideId,
    String? source,
    String? destination,
    num? distance,
  }) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? pessengerId = prefs.getString("passengerId");
      
    final body = {
      "rideId": rideId,
      'passengerId': pessengerId,
      "destination": destination,
    };

    try {
      debugPrint('requestRide');
      debugPrint(body.toString());

      final Response response = await dio.post(
        '/request',
        data: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final MapResponse driverResponse =
            MapResponse.fromJson(response.data as Map<String, dynamic>);
        log(response.data.toString());
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString("driverID", driverResponse.data!.id!.toString());

      
        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          throw AppErrors.processErrorJson(
              e.response?.data as Map<String, dynamic>);
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
