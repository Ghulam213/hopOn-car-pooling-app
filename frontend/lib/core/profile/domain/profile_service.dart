import '../models/user_info_response.dart';
import '../models/user_preferences_response.dart';

abstract class ProfileService {
  Future<UserInfoResponse> getProfile();
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
  });

  Future<PassengerPrefsResponse> getPassengerPrefs();
  Future<UserInfoResponse> getDriverPrefs();
  Future<void> setDriverPrefs({
    String? genderPreference,
    num? maxNumberOfPassengers,
  });
  Future<void> setPassengerPrefs({
    String? genderPreference,
  });
  Future<bool> checkIfRegisteredForDriver();
}
