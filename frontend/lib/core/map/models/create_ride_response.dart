import 'package:hop_on/core/map/models/ride.dart';

class CreateRideResponse {
  int? statusCode;
  String? error;
  dynamic? data;

  CreateRideResponse({this.statusCode, this.error, this.data});

  factory CreateRideResponse.fromJson(json) {
    return CreateRideResponse(
      statusCode: json['statusCode'] as int?,
      error: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Ride.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'error': error,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
