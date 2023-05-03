import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hop_on/core/map/domain/map_service.dart';
import 'package:hop_on/core/map/models/ride_for_passenger_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/error.dart';
import '../../../config/network/network_config.dart';
import '../models/create_ride_response.dart';
import '../models/map_response.dart';

class MapServiceImpl extends MapService {
  final Dio dio = NetworkConfig().dio;

  @override
  Future<RideForPassengerResponse> findRides({
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
   
      final Response response =
          await dio.get('/ride-for-passenger', queryParameters: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final RideForPassengerResponse driverResponse =
            RideForPassengerResponse.fromJson(
                response.data as Map<String, dynamic>);

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(
            response.data['data'] as Map<String, dynamic>);
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
   

      final Response response = await dio.post(
        '/ride/request',
        data: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final MapResponse driverResponse =
            MapResponse.fromJson(response.data as Map<String, dynamic>);

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

  @override
  Future<CreateRideResponse> createRide({
    String? source,
    String? destination,
    String? currentLocation,
    num? totalDistance,
    String? city,
    List<dynamic>? polygonPoints,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? city = prefs.getString("currentCity");
      final String? driverID = prefs.getString("driverId");

      final body = {
        'driverId': driverID ?? 'e0d89a2b-f8da-441a-8182-bc4bb4f945e7',
        "source": source,
        'destination': destination,
        'currentLocation': currentLocation,
        'totalDistance': totalDistance,
        "city": city ?? 'Islamabad',
        'polygonPoints': jsonEncode(polygonPoints)
      };

      final Response response = await dio.post(
        '/ride',
        data: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final CreateRideResponse driverResponse =
            CreateRideResponse.fromJson(response.data as Map<String, dynamic>);

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(
            response.data['data'] as Map<String, dynamic>);
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
  Future<void> updateDriverLoc({
    String? rideId,
    String? currentLocation,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? driverID = prefs.getString("driverId");

      final body = {
        "rideId": rideId ?? '62660ffb-abbd-4c36-b3d6-e0941587c291',
        "entityId": driverID ?? 'e0d89a2b-f8da-441a-8182-bc4bb4f945e7',
        "currentLocation": currentLocation
      };

      final Response response = await dio.post(
        '/ride/driver/current-location',
        data: jsonEncode(body),
      );

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
