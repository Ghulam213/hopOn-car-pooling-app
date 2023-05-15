import 'package:flutter/material.dart';

import '../../../config/network/resources.dart';
import '../domain/profile_service.dart';
import '../models/user_info_response.dart';
import '../service/profile_service_impl.dart';

class ProfileViewModel extends ChangeNotifier {
  late ProfileService _profileService;

  ProfileViewModel() {
    _profileService = ProfileServiceImpl();

    loadLocalDetails();
    getProfile();
  }

  Resource<UserInfoResponse> getProfileResource = Resource.idle();

  String id = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  String locale = '';
  String timezone = '';
  String currentCity = '';
  String gender = '';
  String birthDate = '';
  String profilePic = '';
  String currentMode = '';

  Future<void> loadLocalDetails() async {
    final Map<String, String> details = await ProfileServiceImpl().getStoredProfile();

    // name = details["profileName"]!;
    // email = details["profileEmail"]!;
    // phone = details["profileNumber"]!;
    // id = details["userID"]!;
    // placeHolderName = details["placeHolderName"]!;

    notifyListeners();
  }

  Future<void> getProfile() async {
    try {
      getProfileResource = Resource.loading();
      notifyListeners();

      final UserInfoResponse response = await _profileService.getProfile();

      getProfileResource = Resource.success(response);

      id = getProfileResource.modelResponse!.data!.id!;
      email = getProfileResource.modelResponse!.data!.email.toString();
      firstName = getProfileResource.modelResponse!.data!.firstName!;
      lastName = getProfileResource.modelResponse!.data!.lastName!.toString();
      phone = getProfileResource.modelResponse!.data!.phone!.toString();
      locale = getProfileResource.modelResponse!.data!.locale!;
      timezone = getProfileResource.modelResponse!.data!.timezone.toString();
      currentCity = getProfileResource.modelResponse!.data!.currentCity!;
      gender = getProfileResource.modelResponse!.data!.gender!.toString();
      birthDate = getProfileResource.modelResponse!.data!.birthDate.toString();
      profilePic = getProfileResource.modelResponse!.data!.profilePic!.toString();
      currentMode = getProfileResource.modelResponse!.data!.currentMode!.toString();

      notifyListeners();
    } catch (e) {
      getProfileResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserInfoResponse> updateProfileResource = Resource.idle();

  Future<void> updateProfile({
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
    try {
      updateProfileResource = Resource.loading();
      notifyListeners();


      final UserInfoResponse response = await _profileService.updateUserProfile(
        birthDate: birthDate,
        currentCity: currentCity,
        currentMode: currentMode,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        locale: locale,
        phone: phone,
        profilePic: profilePic,
        timezone: timezone,
        optedInAt: optedInAt,
        active: active,
        verified: verified,
      );

      updateProfileResource = Resource.success(response);

      id = getProfileResource.modelResponse!.data!.id!;
      email = getProfileResource.modelResponse!.data!.email.toString();
      firstName = getProfileResource.modelResponse!.data!.firstName!;
      lastName = getProfileResource.modelResponse!.data!.lastName!.toString();
      phone = getProfileResource.modelResponse!.data!.phone!.toString();
      locale = getProfileResource.modelResponse!.data!.locale!;
      timezone = getProfileResource.modelResponse!.data!.timezone.toString();
      currentCity = getProfileResource.modelResponse!.data!.currentCity!;
      gender = getProfileResource.modelResponse!.data!.gender!.toString();
      birthDate = getProfileResource.modelResponse!.data!.birthDate.toString();
      profilePic = getProfileResource.modelResponse!.data!.profilePic!.toString();
      currentMode = getProfileResource.modelResponse!.data!.currentMode!.toString();

      notifyListeners();
    } catch (e) {
      updateProfileResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserInfoResponse> getPassengerPrefsResource = Resource.idle();

  Future<void> getPassengerPrefs() async {
    try {
      getPassengerPrefsResource = Resource.loading();
      notifyListeners();

      final UserInfoResponse response =
          await _profileService.getPassengerPrefs();
      getPassengerPrefsResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      getPassengerPrefsResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserInfoResponse> setPassengerPrefsResource = Resource.idle();

  Future<void> setPassengerPrefs({
    String? genderPreference,
  }) async {
    try {
      await _profileService.setPassengerPrefs(
        genderPreference: genderPreference,
      );

      notifyListeners();
    } catch (e) {
      setPassengerPrefsResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserInfoResponse> setDriverPrefsResource = Resource.idle();

  Future<void> setDriverPrefs({
    String? genderPreference,
    num? maxNumberOfPassengers,
  }) async {
    try {
      await _profileService.setDriverPrefs(
        genderPreference: genderPreference,
        maxNumberOfPassengers: maxNumberOfPassengers,
      );
    } catch (e) {
      setDriverPrefsResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserInfoResponse> getDriverPrefsResource = Resource.idle();

  Future<void> getDriverPrefs() async {
    try {
      getDriverPrefsResource = Resource.loading();
      notifyListeners();

      final UserInfoResponse response = await _profileService.getDriverPrefs();

      getDriverPrefsResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      getDriverPrefsResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
