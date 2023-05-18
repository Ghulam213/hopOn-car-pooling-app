class GetRidePassengersResponse {
  List<GetRidePassengers>? data;

  GetRidePassengersResponse({this.data});

  factory GetRidePassengersResponse.fromJson(json) {
    return GetRidePassengersResponse(
      data: json['data'] == null
          ? null
          : (json['data'] as List<dynamic>?)
              ?.map(
                  (e) => GetRidePassengers.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
      };
}

class GetRidePassengers {
  String? id;
  String? rideId;
  String? passengerId;
  String? source;
  String? destination;
  int? distance;
  int? fare;
  String? rideStatus;
  String? rideStartedAt;
  String? rideEndedAt;
  String? createdAt;
  String? updatedAt;

  GetRidePassengers(
      {this.id,
      this.rideId,
      this.passengerId,
      this.source,
      this.destination,
      this.distance,
      this.fare,
      this.rideStatus,
      this.rideStartedAt,
      this.rideEndedAt,
      this.createdAt,
      this.updatedAt});

  GetRidePassengers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rideId = json['rideId'];
    passengerId = json['passengerId'];
    source = json['source'];
    destination = json['destination'];
    distance = json['distance'];
    fare = json['fare'];
    rideStatus = json['rideStatus'];
    rideStartedAt = json['rideStartedAt'];
    rideEndedAt = json['rideEndedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rideId'] = rideId;
    data['passengerId'] = passengerId;
    data['source'] = source;
    data['destination'] = destination;
    data['distance'] = distance;
    data['fare'] = fare;
    data['rideStatus'] = rideStatus;
    data['rideStartedAt'] = rideStartedAt;
    data['rideEndedAt'] = rideEndedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
