import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/error.dart';
import '../../../Utils/helpers.dart';
import '../../../config/network/network_config.dart';
import '../domain/profile_service.dart';
import '../models/user_info_response.dart';

class ProfileServiceImpl extends ProfileService {
  final Dio dio = NetworkConfig().dio;

  @override
  Future<UserInfoResponse> getProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString("userID");

      final Response response = await dio.get('/user/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final UserInfoResponse profileResponse =
            UserInfoResponse.fromJson(response.data as Map<String, dynamic>);
        log(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            "profileEmail", profileResponse.data!.email.toString());
        await prefs.setString("profileNumber", profileResponse.data!.phone!);
        await prefs.setString("userID", profileResponse.data!.id!.toString());

        return profileResponse;
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

  Future<Map<String, String>> getStoredProfile() async {
    final Map<String, String> data = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString("profileName");
    final String? email = prefs.getString("profileEmail");
    final String? number = prefs.getString("profileNumber");
    final String? id = prefs.getString("userID");

    data["profileName"] = name ?? "";
    data["profileEmail"] = email ?? "";
    data["profileNumber"] = number ?? "";
    data["userID"] = id ?? "";

    return data;
  }

  @override
  Future<UserInfoResponse> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? locale,
    String? timezone,
    String? currentCity,
    String? gender,
    String? birthDate,
    String? profilePic,
    String? currentMode,
    bool? optedInAt,
    bool? active,
    bool? verified,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userID') ?? '';

    try {
      final Map<String, dynamic> data = {"id": id, "currentMode": 'DRIVER'};

      logger('ProfileServiceImpl: updateUserProfile: Body  $data');
      final Response response = await dio.put(
        '/user/$id',
        data: data,
      );
      logger(
          'ProfileServiceImpl: updateUserProfile: Response ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final UserInfoResponse updateOrderStatusResponse =
            UserInfoResponse.fromJson(response.data as Map<String, dynamic>);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            "profileEmail", updateOrderStatusResponse.data!.email.toString());
        await prefs.setString(
            "profileNumber", updateOrderStatusResponse.data!.phone!);
        await prefs.setString(
            "userID", updateOrderStatusResponse.data!.id!.toString());

        return updateOrderStatusResponse;
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
      log("ProfileServiceImpl: updateUserProfile(). $e");
      throw e.toString();
    }
  }

  @override
  Future<UserInfoResponse> getDriverPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? driverId = prefs.getString("driverID");

      final Response response = await dio.get(
        '/driver/$driverId/preferences',
        queryParameters: {'id': driverId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final UserInfoResponse profileResponse =
            UserInfoResponse.fromJson(response.data as Map<String, dynamic>);

        return profileResponse;
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
  Future<UserInfoResponse> getPassengerPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? passengerId = prefs.getString("passengerID");

      final Response response = await dio.get(
        '//passenger/$passengerId/preferences',
        queryParameters: {'id': passengerId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final UserInfoResponse profileResponse =
            UserInfoResponse.fromJson(response.data as Map<String, dynamic>);

        return profileResponse;
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
  Future<void> setDriverPrefs(
      {String? genderPreference, num? maxNumberOfPassengers}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? driverId = prefs.getString("driverID");

      final Map<String, dynamic> body = {
        "genderPreference": genderPreference,
        "maxNumberOfPassengers": maxNumberOfPassengers
      };

      await dio.post(
        '/driver/$driverId/preferences',
        queryParameters: {'id': driverId},
        data: body,
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

  @override
  Future<dynamic> setPassengerPrefs({String? genderPreference}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? passengerId = prefs.getString("passengerID");

      final Map<String, dynamic> body = {"genderPreference": genderPreference};

      await dio.post(
        '/passenger/$passengerId/preferences',
        queryParameters: {'id': passengerId},
        data: body,
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
