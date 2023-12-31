import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/map/domain/map_service.dart';
import 'package:hop_on/core/map/models/request_ride_response.dart';
import 'package:hop_on/core/map/models/ride_for_passenger_response.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/error.dart';
import '../../../config/network/network_config.dart';
import '../models/create_ride_response.dart';
import '../models/driver_response_general.dart';
import '../models/get_ride_location_response.dart';
import '../models/get_ride_passengers_response.dart';

class MapServiceImpl extends MapService {
  final Dio dio = NetworkConfig().dio;

  @override
  Future<RideForPassengerResponse> findRides({
    String? source,
    String? destination,
    num? distance,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? city = prefs.getString("currentCity");
      final String pessengerId = prefs.getString("passengerID") ?? '';

      final body = {
        "source": source,
        'destination': destination,
        "city": city ?? 'Islamabad',
        "distance": distance,
        "passengerId": pessengerId,
      };
      logger("MapServiceImpl: findRides() Body: $body");

      final Response response =
          await dio.get('/ride-for-passenger', queryParameters: body);

      logger("MapServiceImpl: findRides() Response: ${response.data}");

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
      await Sentry.captureMessage(
          'MapServiceImpl: findRides() ${e.toString()}');
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
  Future<RequestRideResponse> requestRide({
    String? rideId,
    String? passengerSource,
    String? passengerDestination,
    String? driverName,
    num? distance,
    num? fare,
    num? ETA,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String user = prefs.getString("user") ?? '';
    final String pessengerId = prefs.getString("passengerID") ?? '';

    final body = {
      "rideId": rideId,
      "passengerId": pessengerId,
      "passengerName": jsonDecode(user)['firstName'],
      "driverName": driverName,
      "passengerSource": passengerSource,
      "passengerDestination": passengerDestination,
      "distance": distance,
      "ETA": ETA,
      "fare": fare
    };

    logger("MapServiceImpl: requestRide() Body: $body");
    try {
      final Response response = await dio.post(
        '/ride/request',
        data: jsonEncode(body),
      );

      logger("MapServiceImpl: requestRide() Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final RequestRideResponse driverResponse =
            RequestRideResponse.fromJson(response.data as Map<String, dynamic>);
        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: requestRide()  ${e.toString()}');
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
  Future<CreatedRideResponse> createRide({
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
      final String? driverID = prefs.getString("driverID");

      final body = {
        'driverId': driverID ?? '',
        "source": source!.trim(),
        'destination': destination!.trim(),
        'currentLocation': currentLocation,
        'totalDistance': totalDistance,
        "city": city ?? 'Islamabad',
        'polygonPoints': jsonEncode(polygonPoints)
      };

      logger("MapServiceImpl: createRide() Body: $body");
      final Response response = await dio.post(
        '/ride',
        data: body,
      );

      logger("MapServiceImpl: createRide() Response: $response.data");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final CreatedRideResponse driverResponse =
            CreatedRideResponse.fromJson(response.data as Map<String, dynamic>);

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(
            response.data['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: createRide()  ${e.toString()}');
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
  Future<RequestRideResponse> acceptRide({
    String? rideId,
    String? passengerSource,
    String? passengerId,
    String? passengerDestination,
    String? driverName,
    num? distance,
    num? fare,
    num? ETA,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString("user") ?? '';

    final body = {
      "rideId": rideId,
      "passengerId": passengerId,
      "passengerName": jsonDecode(user)['firstName'],
      "driverName": driverName,
      "passengerSource": passengerSource,
      "passengerDestination": passengerDestination,
      "distance": distance,
      "ETA": ETA,
      "fare": fare
    };
    logger("MapServiceImpl: acceptRide() Body: $body");

    try {
      final Response response = await dio.post(
        '/ride/accept-request',
        data: body,
      );
      logger("MapServiceImpl: acceptRide() Response: $response.data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final RequestRideResponse driverResponse =
            RequestRideResponse.fromJson(response.data as Map<String, dynamic>);

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: acceptRide()  ${e.toString()}');
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
  Future<RequestRideResponse> rejectRide({
    String? rideId,
    required String? passengerId,
    String? passengerSource,
    String? passengerDestination,
    String? driverName,
    num? distance,
    num? fare,
    num? ETA,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString("user") ?? '';


    final body = {
      "rideId": rideId,
      "passengerId": passengerId,
      "passengerName": jsonDecode(user)['firstName'],
      "driverName": driverName,
      "passengerSource": passengerSource,
      "passengerDestination": passengerDestination,
      "distance": distance,
      "ETA": ETA,
      "fare": fare
    };
    logger("MapServiceImpl: rejectRide() Body: $body");
    try {
      final Response response = await dio.post(
        '/ride/reject-request',
        data: jsonEncode(body),
      );

      logger("MapServiceImpl: rejectRide() RAesponse: $response.data");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final RequestRideResponse driverResponse =
            RequestRideResponse.fromJson(response.data as Map<String, dynamic>);

        return driverResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: rejectRide() ${e.toString()}');
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
      final String? driverID = prefs.getString("driverID");

      final body = {
        "rideId": rideId,
        "entityId": driverID,
        "currentLocation": currentLocation
      };

      logger("MapServiceImpl: updateDriverLoc() Body: $body");
      await dio.post(
        '/ride/driver/current-location',
        data: jsonEncode(body),
      );

      logger("MapServiceImpl: updateDriverLoc() Response");
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: updateDriverLoc() ${e.toString()}');
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
  Future<void> updatePassengerLoc({
    String? rideId,
    String? currentLocation,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? passengerId = prefs.getString("passengerID");

      final body = {
        "rideId": rideId,
        "entityId": passengerId,
        "currentLocation": currentLocation
      };

      logger("MapServiceImpl: updatePassengerLoc() Body: $body");
      await dio.post(
        '/ride/passenger/current-location',
        data: jsonEncode(body),
      );

      logger("MapServiceImpl: updatePassengerLoc() Response");
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: updatePassengerLoc() ${e.toString()}');
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
  Future<GetRideResponse> getRideLocation(
    String rideId,
  ) async {
    try {

      final Response response = await dio.get(
        '/ride/$rideId/current-location',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final GetRideResponse rideResponse =
            GetRideResponse.fromJson(response.data as Map<String, dynamic>);

        logger("MapServiceImpl: getRideLocation() Response:$response}");

        return rideResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: getRideLocation() ${e.toString()}');
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
  Future<DriverGeneralResponse> changePassengerStatus(
    String rideId,
    String? passengerId,
    String status,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? passengerId = prefs.getString("passengerID");
    try {
      final body = {
        "rideId": rideId,
        "passengerId": passengerId,
        "status": status
      };

      logger("MapServiceImpl: changePassengerStatus() Body: $body");
      final Response response = await dio.post(
        '/ride/passenger/status',
        data: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverGeneralResponse passengerResponse =
            DriverGeneralResponse.fromJson(
                response.data as Map<String, dynamic>);

        logger("MapServiceImpl: changePassengerStatus() Response:$response}");

        return passengerResponse;
      } else {
        throw AppErrors.processErrorJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      await Sentry.captureMessage(
          'MapServiceImpl: changePassengerStatus() ${e.toString()}');
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
  Future<DriverGeneralResponse> rideCompleted(
    String rideId,
  ) async {
    try {
      final body = {
        "rideId": rideId,
      };

      logger("MapServiceImpl: rideCompleted() Body: $body");
      final Response response = await dio.post(
        '/ride/$rideId/complete',
        queryParameters: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final DriverGeneralResponse rideResponse =
            DriverGeneralResponse.fromJson(
                response.data as Map<String, dynamic>);

        logger("MapServiceImpl: rideCompleted() Response:$response}");

        return rideResponse;
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
  Future<GetRidePassengersResponse> getRidePassengers(String rideId) async {
    try {
      logger("MapServiceImpl: getRidePassengers() id : $rideId");
      final Response response = await dio.get(
        '/ride/$rideId/passengers',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final GetRidePassengersResponse rideResponse =
            GetRidePassengersResponse.fromJson(
                response.data as Map<String, dynamic>);

        logger("MapServiceImpl: getRidePassengers() Response:$response}");

        return rideResponse;
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
