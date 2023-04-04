import 'dart:ffi';

import 'package:hop_on/core/map/models/map_response.dart';

abstract class MapService {
  Future<MapResponse> findRides({
    String? source,
    String? destination,
  });

  Future<MapResponse> requestRide({
    String? rideId,
    String? source,
    String? destination,
    num? distance,
  });
}
