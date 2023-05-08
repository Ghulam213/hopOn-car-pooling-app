
import '../models/user_info_response.dart';

abstract class ProfileService {
  Future<UserInfoResponse> getProfile();
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
  });
}
