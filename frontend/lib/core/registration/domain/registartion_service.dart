
import '../models/driver_response.dart';

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
  });
  Future<DriverInfoResponse> getDriver();
  Future<DriverInfoResponse> updateDriverInfo(String? userId);
  Future<DriverInfoResponse> searchDriver(String? userId);
}
