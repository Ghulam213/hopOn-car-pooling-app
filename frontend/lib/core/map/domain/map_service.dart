import 'package:hop_on/core/map/models/map_response.dart';

import '../models/create_ride_response.dart';
import '../models/ride_for_passenger_response.dart';


abstract class MapService {
  Future<RideForPassengerResponse> findRides({
    String? source,
    String? destination,
  });

  Future<MapResponse> requestRide({
    String? rideId,
    String? source,
    String? destination,
    num? distance,
  });

  Future<CreateRideResponse> createRide({
    String? source,
    String? destination,
    String? currentLocation,
    num? totalDistance,
    String? city,
    List<dynamic>? polygonPoints,
  });

  Future<void> updateDriverLoc({
    String? rideId,
    String? currentLocation,
  });

}
