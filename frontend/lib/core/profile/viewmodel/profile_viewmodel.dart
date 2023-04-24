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
      updateProfileResource = Resource.loading();
      notifyListeners();

      final UserInfoResponse response = await _profileService.updateUserProfile(
        id: id,
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
}
