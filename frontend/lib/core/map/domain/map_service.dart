import 'package:hop_on/core/map/models/request_ride_response.dart';

import '../models/create_ride_response.dart';
import '../models/driver_response_general.dart';
import '../models/get_ride_location_response.dart';
import '../models/ride_for_passenger_response.dart';

abstract class MapService {
  Future<RideForPassengerResponse> findRides({
    String? source,
    String? destination,
    num? distance

  });

  Future<RequestRideResponse> requestRide({
    required String? rideId,
    required String? passengerSource,
    required String? passengerDestination,
    required String? driverName,
    required num? distance,
    required num? fare,
    required num? ETA,
  });

  Future<void> acceptRide({
    required String? rideId,
    required String? passengerSource,
    required String? passengerDestination,
    required String? driverName,
    required num? distance,
    required num? fare,
    required num? ETA,
  });

  Future<void> rejectRide({
    required String? rideId,
    required String? passengerSource,
    required String? passengerDestination,
    required String? driverName,
    required num? distance,
    required num? fare,
    required num? ETA,
  });

  Future<CreatedRideResponse> createRide({
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

  Future<void> updatePassengerLoc({
    String? rideId,
    String? currentLocation,
  });

  Future<GetRideResponse> getRideLocation(
    String rideId,
  );

  Future<DriverGeneralResponse> changePassengerStatus(
    String rideId,
    String status,
  );

  Future<DriverGeneralResponse> rideCompleted(
    String rideId,
  );
}
