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

    logger('ProfileServiceImpl: updateUserProfile: $id $currentMode');

    try {
      final Map<String, dynamic> data = {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "locale": locale,
        "timezone": timezone,
        "currentCity": currentCity,
        "gender": gender,
        "birthDate": birthDate,
        "profilePic": profilePic,
        "optedInAt": optedInAt,
        "active": active,
        "verified": verified,
        "currentMode": 'DRIVER'
      };
      // final FormData formData = FormData.fromMap(data);
      final Response response = await dio.put(
        '/user/$id',
        data: data,
      );

      logger('ProfileServiceImpl: updateUserProfile: ${response.data}');
     
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
}
