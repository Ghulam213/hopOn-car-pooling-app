import 'package:hop_on/core/registration/models/driver.dart';

class MapResponse {
  int? code;
  String? error;
  Driver? data;

  MapResponse({this.code, this.error, this.data});

  factory MapResponse.fromJson(Map<String, dynamic> json) {
    return MapResponse(
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
