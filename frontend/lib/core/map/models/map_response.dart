import 'package:hop_on/core/map/models/ride.dart';
import 'package:hop_on/core/registration/models/driver.dart';

class MapResponse {
  int? code;
  String? error;
  Ride? data;

  MapResponse({this.code, this.error, this.data});

  factory MapResponse.fromJson(Map<String, dynamic> json) {
    return MapResponse(
      code: json['statusCode'] as int?,
      error: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Ride.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'error': error,
        'data': data?.toJson(),
      };
}
