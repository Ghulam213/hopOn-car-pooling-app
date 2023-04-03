import 'dart:ffi';

import '../models/driver_response.dart';

abstract class RegistrationService {
  Future<DriverInfoResponse> registerDriver(String? userId);
  Future<DriverInfoResponse> getDriver(String? userId);
  Future<DriverInfoResponse> updateDriverInfo(String? userId);
  Future<DriverInfoResponse> searchDriver(String? userId);
}
