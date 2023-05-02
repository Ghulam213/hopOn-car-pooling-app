import 'dart:convert';

import 'package:flutter/foundation.dart';

class Ride {
  final String? rideId;
  final String? driverId;
  final String? source;
  final String? destination;
  final num? totalDistance;
  final num? totalFare;
  final String? rideStatus;
  final String? currentLocation;
  final String? city;
  final String? rideStartedAt;
  final String? rideEndedAt;

  final List<dynamic>? polygonPoints;

  Ride({
    this.rideId,
    this.driverId,
    this.source,
    this.destination,
    this.totalDistance,
    this.totalFare,
    this.rideStatus,
    this.currentLocation,
    this.city,
    this.rideStartedAt,
    this.rideEndedAt,
    this.polygonPoints,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {

    List<dynamic> points = jsonDecode(json['polygonPoints']);
    // dynamic? polygonPoints =
    //     points.map((point) => List<double>.from(point)).toList();
    return Ride(
      rideId: json['id'] as String?,
      driverId: json['driverId'] as String?,
      source: json['source'] as String?,
      destination: json['destination'] as String?,
      totalDistance: json['totalDistance'] as num?,
      totalFare: json['totalFare'] as num?,
      rideStatus: json['rideStatus'] as String?,
      currentLocation: json['currentLocation'] as String?,
      city: json['city'] as String?,
      rideStartedAt: json['rideStartedAt'] as String?,
      rideEndedAt: json['rideEndedAt'] as String?,
      polygonPoints: points,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": rideId,
        "driverId": driverId,
        "source": source,
        "destination": destination,
        "totalDistance": totalDistance,
        "totalFare": totalFare,
        "rideStatus": rideStatus,
        "city": city,
        "currentLocation": currentLocation,
        "rideStartedAt": rideStartedAt,
        "rideEndedAt": rideEndedAt,
        'polygonPoints': polygonPoints!.toList(), // TO DO : verify
      };
}

class Coordinates {
  List<List<double>> data;

  Coordinates({required this.data});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    debugPrint('HERRRRR');

    return Coordinates(
        data: List<List<double>>.from(json['polygonPoints'].map(
            (list) => List<double>.from(list.map((item) => item.toDouble())))));
  }
}
