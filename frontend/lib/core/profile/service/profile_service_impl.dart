import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/error.dart';
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

      final Response response = await dio.get('user/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final UserInfoResponse profileResponse = UserInfoResponse.fromJson(response.data as Map<String, dynamic>);
        log(response.data.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("profileEmail", profileResponse.data!.email.toString());
        await prefs.setString("profileNumber", profileResponse.data!.phone!);
        await prefs.setString("userID", profileResponse.data!.id!.toString());

        return profileResponse;
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
    required String id,
    required String firstName,
    required String lastName,
    required String phone,
    required String locale,
    required String timezone,
    required String currentCity,
    required String gender,
    required String birthDate,
    required String profilePic,
    required String currentMode,
    required bool optedInAt,
    required bool active,
    required bool verified,
  }) async {
    try {
      final Map<String, dynamic> data = {
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
        "currentMode": currentMode
      };

      final FormData formData = FormData.fromMap(data);

      final Response response = await dio.put(
        'user/$id',
        data: formData,
      );
      log("ProfileServiceImpl: updateUserProfile(). ${response.data.toString()}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final UserInfoResponse updateOrderStatusResponse =
            UserInfoResponse.fromJson(response.data as Map<String, dynamic>);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("profileEmail", updateOrderStatusResponse.data!.email.toString());
        await prefs.setString("profileNumber", updateOrderStatusResponse.data!.phone!);
        await prefs.setString("userID", updateOrderStatusResponse.data!.id!.toString());

        return updateOrderStatusResponse;
      } else {
        log("ProfileServiceImpl: updateUserProfile(). ${response.data}");
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
      log("ProfileServiceImpl: updateUserProfile(). $e");
      throw e.toString();
    }
  }
}
