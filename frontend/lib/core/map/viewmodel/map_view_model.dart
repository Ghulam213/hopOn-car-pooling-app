import 'package:flutter/material.dart';
import 'package:hop_on/core/map/models/map_response.dart';

import '../../../config/network/resources.dart';
import '../domain/map_service.dart';
import '../models/ride.dart';
import '../service/map_service_impl.dart';

class MapViewModel extends ChangeNotifier {
  late MapService _mapService;

  MapViewModel() {
    _mapService = MapServiceImpl();
  }

  Resource<MapResponse> findRidesResource = Resource.idle();

  String rideId = '';
  String driverId = '';
  String source = '';
  String destination = '';
  num? totalDistance = 0;
  num? totalFare = 0;

  String rideStatus = "ON_GOING";
  String currentLocation = '';
  String city = '';
  String rideStartedAt = '';
  String rideEndedAt = '';
  List<LatLng>? polygonPoints = [
    LatLng(latitude: 72.9914673283913, longitude: 33.64333419508494)
  ];




  Future<void> findRides({
    String? source,
    String? destination,
  }) async {
    try {
      findRidesResource = Resource.loading();
      notifyListeners();

      final MapResponse response = await _mapService.findRides(
        source: source,
        destination: destination,
      );

  
      debugPrint(response.toString());
      findRidesResource = Resource.success(response);

      rideId = findRidesResource.modelResponse!.data!.rideId.toString();
      driverId = findRidesResource.modelResponse!.data!.driverId.toString();
      source = findRidesResource.modelResponse!.data!.source.toString();

      destination =
          findRidesResource.modelResponse!.data!.destination.toString();
      totalDistance = findRidesResource.modelResponse!.data!.totalDistance;
      totalFare = findRidesResource.modelResponse!.data!.totalFare;

      rideStatus = findRidesResource.modelResponse!.data!.rideStatus.toString();
      currentLocation =
          findRidesResource.modelResponse!.data!.currentLocation.toString();
      city = findRidesResource.modelResponse!.data!.city.toString();

      rideStartedAt =
          findRidesResource.modelResponse!.data!.rideStartedAt.toString();
      rideEndedAt =
          findRidesResource.modelResponse!.data!.rideEndedAt.toString();
      polygonPoints = findRidesResource.modelResponse!.data!.polygonPoints;


      notifyListeners();
    } catch (e) {
      findRidesResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<MapResponse> requestRideResource = Resource.idle();

  Future<void> requestRide({
    required String? rideId,
    required String? source,
    required String? destination,
    required num? distance,
  }) async {
    try {
      requestRideResource = Resource.loading();
      notifyListeners();

      final MapResponse response = await _mapService.requestRide(
        rideId: rideId,
        source: source,
        destination: destination,
        distance: distance,
      );

      requestRideResource = Resource.success(response);
      // id = requestRideResource.modelResponse!.data!.id!.toString();
      // active = requestRideResource.modelResponse!.data!.active.toString();

      notifyListeners();
    } catch (e) {
      requestRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
