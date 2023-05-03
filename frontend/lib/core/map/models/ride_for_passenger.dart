// ignore_for_file: non_constant_identifier_names

class RideForPassenger {
  final String? id;
  final String? driverId;
  final String? driverName;
  final String? driverGender;
  final String? vehicleName;
  final String? vehicleRegNo;
  final num? alreadySeatedPassengerCount;
  final num? fare;
  final num? ETA;
  final num? driverRating;

  RideForPassenger({
    this.id,
    this.driverId,
    this.driverName,
    this.driverGender,
    this.vehicleName,
    this.vehicleRegNo,
    this.alreadySeatedPassengerCount,
    this.fare,
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
      vehicleRegNo: json['vehicleRegNo'] as String?,
      alreadySeatedPassengerCount: json['alreadySeatedPassengerCount'] as num?,
      fare: json['fare'] as num?,
      ETA: json['ETA'] as num?,
      driverRating: json['driverRating'] as num?,
    );
  }
}
