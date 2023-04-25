class NotificationDataModel {
  String? rideId;
  String? passengerId;
  String? passengerName;
  String? driverName;
  String? passengerSource;
  String? passengerDestination;
  String? type;
  double? distance;
  double? fare;
  double? eta;

  NotificationDataModel({
    this.rideId,
    this.passengerId,
    this.passengerName,
    this.driverName,
    this.passengerSource,
    this.passengerDestination,
    this.type,
    this.distance,
    this.fare,
    this.eta,
  });

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    rideId = json['rideId'];
    passengerId = json['passengerId'];
    passengerName = json['passengerName'];
    driverName = json['driverName'];
    passengerSource = json['passengerSource'];
    passengerDestination = json['passengerDestination'];
    type = json['type'];
    distance = double.parse(json['distance']);
    fare = double.parse(json['fare']);
    eta = double.parse(json['ETA']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['rideId'] = rideId;
    data['passengerId'] = passengerId;
    data['passengerName'] = passengerName;
    data['driverName'] = driverName;
    data['passengerSource'] = passengerSource;
    data['passengerDestination'] = passengerDestination;
    data['type'] = type;
    data['distance'] = distance;
    data['fare'] = fare;
    data['ETA'] = eta;
    return data;
  }
}
