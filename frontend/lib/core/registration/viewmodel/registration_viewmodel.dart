import 'package:flutter/material.dart';
import 'package:hop_on/core/registration/models/driver_response.dart';

import '../../../config/network/resources.dart';
import '../domain/registartion_service.dart';
import '../service/registration_service_impl.dart';

class RegistrationViewModel extends ChangeNotifier {
  late RegistrationService _registrationService;

  RegistrationViewModel() {
    _registrationService = RegistrationServiceImpl();
  }

  Resource<DriverInfoResponse> getDriverResource = Resource.idle();

  String id = '';
  String active = '';
  String cnicBack = '';
  String cnicFront = '';
  String licenseBack = '';
  String licenseFront = '';
  String userId = '';
  String verified = '';




  Future<void> getDriver(String? userId) async {
    try {
      getDriverResource = Resource.loading();
      notifyListeners();

      final DriverInfoResponse response =
          await _registrationService.getDriver(userId);

      getDriverResource = Resource.success(response);

      id = getDriverResource.modelResponse!.data!.id!.toString();

      active = getDriverResource.modelResponse!.data!.active.toString();
      cnicBack = getDriverResource.modelResponse!.data!.cnicBack.toString();
      cnicFront = getDriverResource.modelResponse!.data!.cnicFront.toString();
      licenseBack =
          getDriverResource.modelResponse!.data!.licenseBack.toString();
      licenseFront =
          getDriverResource.modelResponse!.data!.licenseFront.toString();
      // timezone = getDriverResource.modelResponse!.data!.user timezone.toString();
      userId = getDriverResource.modelResponse!.data!.userId.toString();
      // gender = getDriverResource.modelResponse!.data!.vehicles toString();
      verified = getDriverResource.modelResponse!.data!.verified.toString();

      notifyListeners();
    } catch (e) {
      getDriverResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<DriverInfoResponse> updateProfileResource = Resource.idle();

  Future<void> registerDriver({
    required String userId,
    required String cnicFront,
    required String cnicBack,
    required String licenseFront,
    required String licenseBack,
    required String vehicleType,
    required String vehicleBrand,
    required String vehicleModel,
    required String vehicleColor,
    required String vehiclePhoto,
    required String vehicleRegImage,
  }) async {
    try {
      updateProfileResource = Resource.loading();
      notifyListeners();

      final DriverInfoResponse response =
          await _registrationService.registerDriver(
        userId: userId,
        cnicFront: cnicFront,
        cnicBack: cnicBack,
        licenseFront: licenseFront,
        licenseBack: licenseBack,
        vehicleType: vehicleType,
        vehicleBrand: vehicleBrand,
        vehicleModel: vehicleModel,

vehicleColor: vehicleColor,
        vehiclePhoto: vehiclePhoto,
        vehicleRegImage: vehicleRegImage,
      );

      updateProfileResource = Resource.success(response);
      id = getDriverResource.modelResponse!.data!.id!.toString();
      active = getDriverResource.modelResponse!.data!.active.toString();
      cnicBack = getDriverResource.modelResponse!.data!.cnicBack.toString();
      cnicFront = getDriverResource.modelResponse!.data!.cnicFront.toString();
      licenseBack =
          getDriverResource.modelResponse!.data!.licenseBack.toString();
      licenseFront =
          getDriverResource.modelResponse!.data!.licenseFront.toString();
      userId = getDriverResource.modelResponse!.data!.userId.toString();
      verified = getDriverResource.modelResponse!.data!.verified.toString();

      notifyListeners();
    } catch (e) {
      updateProfileResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
