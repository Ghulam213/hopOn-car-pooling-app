// ignore_for_file: non_constant_identifier_names

class RideForPassenger {
  final String? id;
  final String? driverId;
  final String? driverName;
  final String? driverGender;
  final String? vehicleName;
  final String? vehicleRegNo;
  String? source;
  String? destination;
  final num? alreadySeatedPassengerCount;
  final num? fare;
  final num? ETA;
  final num? driverRating;
  final String? distance;

  RideForPassenger({
    this.id,
    this.driverId,
    this.driverName,
    this.driverGender,
    this.vehicleName,
    this.vehicleRegNo,
    this.alreadySeatedPassengerCount,
    this.fare,
    this.source,
    this.distance,
    this.destination,
    this.ETA,
    this.driverRating,
  });

  factory RideForPassenger.fromJson(Map<String, dynamic> json) {
    return RideForPassenger(
      id: json['id'] as String?,
      driverId: json['driverId'] as String?,
      driverName: json['driverName'] as String?,
      driverGender: json['driverGender'] as String?,
      vehicleName: json['vehicleName'] as String?,
      source: json['source'] as String?,
      destination: json['destination'] as String?,
      vehicleRegNo: json['vehicleRegNo'] as String?,
      alreadySeatedPassengerCount: json['alreadySeatedPassengerCount'] as num?,
      fare: json['fare'] as num?,
      ETA: json['ETA'] as num?,
      distance: json['distance'] as String?,
      driverRating: json['driverRating'] as num?,
    );
  }
}
