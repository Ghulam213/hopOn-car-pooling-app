class CreatedRideResponse {
  CreatedRide? data;

  CreatedRideResponse({this.data});

  CreatedRideResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CreatedRide.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CreatedRide {
  String? id;
  String? driverId;
  String? source;
  String? destination;
  int? totalDistance;
  int? totalFare;
  String? rideStatus;
  String? city;
  String? rideStartedAt;
  String? rideEndedAt;
  String? polygonPoints;

  CreatedRide(
      {this.id,
      this.driverId,
      this.source,
      this.destination,
      this.totalDistance,
      this.totalFare,
      this.rideStatus,
      this.city,
      this.rideStartedAt,
      this.rideEndedAt,
      this.polygonPoints});

  CreatedRide.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driverId'];
    source = json['source'];
    destination = json['destination'];
    totalDistance = json['totalDistance'];
    totalFare = json['totalFare'];
    rideStatus = json['rideStatus'];
    city = json['city'];
    rideStartedAt = json['rideStartedAt'];
    rideEndedAt = json['rideEndedAt'];
    polygonPoints = json['polygonPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driverId'] = driverId;
    data['source'] = source;
    data['destination'] = destination;
    data['totalDistance'] = totalDistance;
    data['totalFare'] = totalFare;
    data['rideStatus'] = rideStatus;
    data['city'] = city;
    data['rideStartedAt'] = rideStartedAt;
    data['rideEndedAt'] = rideEndedAt;
    data['polygonPoints'] = polygonPoints;
    return data;
  }
}
