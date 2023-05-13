import '../models/driver_response.dart';
import '../models/file_upload_response.dart';

abstract class RegistrationService {
  Future<DriverInfoResponse> registerDriver({
    String? userId,
    String? cnicFront,
    String? cnicBack,
    String? licenseFront,
    String? licenseBack,
    String? vehicleType,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleColor,
    String? vehiclePhoto,
    String? vehicleRegImage,
      String? vehicleRegNo
  });
  Future<DriverInfoResponse> getDriver();
  Future<DriverInfoResponse> updateDriverInfo(String? userId);
  Future<DriverInfoResponse> searchDriver(String? userId);
  Future<FileUploadResponse> uploadFile();
}
