class GetRideResponse {
  Data? data;

  GetRideResponse({this.data});

  GetRideResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? rideId;
  Rider? driver;
  List<Rider>? passengers;

  Data({this.rideId, this.driver, this.passengers});

  Data.fromJson(Map<String, dynamic> json) {
    rideId = json['rideId'];
    driver = json['driver'] != null ? Rider.fromJson(json['driver']) : null;
    if (json['passengers'] != null) {
      passengers = <Rider>[];
      json['passengers'].forEach((v) {
        passengers!.add(Rider.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rideId'] = rideId;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (passengers != null) {
      data['passengers'] = passengers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rider {
  String? id;
  String? currentLocation;

  Rider({this.id, this.currentLocation});

  Rider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentLocation = json['currentLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['currentLocation'] = currentLocation;
    return data;
  }
}
