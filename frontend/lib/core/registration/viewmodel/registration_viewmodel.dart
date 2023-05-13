import 'package:flutter/material.dart';
import 'package:hop_on/core/registration/models/driver_response.dart';

import '../../../Utils/helpers.dart';
import '../../../config/network/resources.dart';
import '../domain/registartion_service.dart';
import '../models/file_upload_response.dart';
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

  Future<void> getDriver() async {
    try {
      getDriverResource = Resource.loading();
      notifyListeners();

      final DriverInfoResponse response =
          await _registrationService.getDriver();

      debugPrint('getDriver');
      debugPrint(response.toString());
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

  Resource<DriverInfoResponse> registerDriverResource = Resource.idle();

  Future<void> registerDriver(
      {required String userId,
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
      required String vehicleRegNo}) async {
    try {
      registerDriverResource = Resource.loading();
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
              vehicleRegNo: vehicleRegNo);

      registerDriverResource = Resource.success(response);
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
      registerDriverResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<FileUploadResponse> fileUploadResource = Resource.idle();

  Future<String?> uploadFile() async {
    try {
      fileUploadResource = Resource.loading();
      notifyListeners();

      logger('FileUploadResponse CALLED');
      final FileUploadResponse response =
          await _registrationService.uploadFile();

      logger('FileUploadResponse');
      logger(response.toString());
      fileUploadResource = Resource.success(response);
      notifyListeners();

      return fileUploadResource.modelResponse?.data?.fileUrl;
    } catch (e) {
      getDriverResource = Resource.failed(e.toString());
      notifyListeners();
      return '';
    }
  }
}
