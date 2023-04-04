import 'package:latlong2/latlong.dart';

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
  final List<LatLng>? polygonPoints;

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
      polygonPoints: (json['polygonPoints'] as List)
          .map((latLngJson) => LatLng.fromJson(latLngJson))
          .toList(),
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

class LatLng {
  double latitude;
  double longitude;

  LatLng({required this.latitude, required this.longitude});

  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
