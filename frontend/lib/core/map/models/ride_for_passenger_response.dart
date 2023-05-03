import 'package:hop_on/core/map/models/ride_for_passenger.dart';

class RideForPassengerResponse {
  int? statusCode;
  String? error;
  dynamic data;

  RideForPassengerResponse({this.statusCode, this.error, this.data});

  factory RideForPassengerResponse.fromJson(json) {
    return RideForPassengerResponse(
      statusCode: json['statusCode'] as int?,
      error: json['message'] as String?,
      data: json['data'] == null
          ? null
          : (json['data'] as List<dynamic>?)
              ?.map((e) => RideForPassenger.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'error': error,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
