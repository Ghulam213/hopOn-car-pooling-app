import 'package:hop_on/core/registration/models/driver.dart';

import '../../auth/models/user.dart';

class GetRideResponse {
  dynamic data;

  GetRideResponse({this.data});

  factory GetRideResponse.fromJson(json) {
    return GetRideResponse(
        data: json['data'] == null
            ? null
            : RideInfo.fromJson(json['data'] as Map<String, dynamic>));
  }

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()),
      };
}

class RideInfo {
  final String? rideId;
  final Driver? driver;
  final List<User>? passengers;

  RideInfo({
    this.rideId,
    this.driver,
    this.passengers,
  });

  factory RideInfo.fromJson(Map<String, dynamic> json) {
    return RideInfo(
      rideId: json['rideId'],
      driver: json['driver'],
      passengers: json['passengers'],
    );
  }

  Map<String, dynamic> toJson() => {
        "rideId": rideId,
        "driver": driver,
        'passengers': passengers!.toList(), // TO DO : verify
      };
}
