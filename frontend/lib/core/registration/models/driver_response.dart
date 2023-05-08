import 'package:hop_on/core/registration/models/driver.dart';

class DriverInfoResponse {
  int? code;
  String? error;
  Driver? data;

  DriverInfoResponse({this.code, this.error, this.data});

  factory DriverInfoResponse.fromJson(Map<String, dynamic> json) {
    return DriverInfoResponse(
      code: json['statusCode'] as int?,
      error: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Driver.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'error': error,
        'data': data?.toJson(),
      };
}
