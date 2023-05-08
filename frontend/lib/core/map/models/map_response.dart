import 'package:hop_on/core/map/models/ride.dart';

class MapResponse {
  int? code;
  String? error;
  List<Ride>? data;

  MapResponse({this.code, this.error, this.data});

  factory MapResponse.fromJson(json) {
    return MapResponse(
    
      data: json.data['data'] == null
          ? null
          : (json.data['data'] as List<dynamic>?)
              ?.map((e) => Ride.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'error': error,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
