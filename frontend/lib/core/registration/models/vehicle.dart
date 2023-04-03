class Vehicle {
  String? id;
  String? vehicleType;
  String? vehicleBrand;
  String? vehicleModel;
  String? vehicleColor;
  String? vehiclePhoto;
  String? vehicleRegImage;
  String? driverId;
  String? driver;

  Vehicle(
      {this.id,
      this.vehicleType,
      this.vehicleBrand,
      this.vehicleModel,
      this.vehicleColor,
      this.vehiclePhoto,
      this.vehicleRegImage,
      this.driverId,
      this.driver});

  factory Vehicle.fromJson(dynamic json) {
    return Vehicle(
      id: json['id'] as String?,
      vehicleType: json['vehicleType'] as String?,
      vehicleBrand: json['vehicleBrand'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleColor: json['vehicleColor'] as String?,
      vehiclePhoto: json['vehiclePhoto'] as String?,
      vehicleRegImage: json['vehicleRegImage'] as String?,
      driverId: json['driverId'] as String?,
      driver: json['driver'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicleType": vehicleType,
        "vehicleBrand": vehicleBrand,
        "vehicleModel": vehicleModel,
        "vehicleColor": vehicleColor,
        "vehiclePhoto": vehiclePhoto,
        "vehicleRegImage": vehicleRegImage,
        "driverId": driverId,
        "driver": driver,
      };
}
