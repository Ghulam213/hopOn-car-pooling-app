import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hop_on/Utils/constants.dart';
import 'package:hop_on/core/map/models/map_response.dart';

import '../../../config/network/resources.dart';
import '../domain/map_service.dart';
import '../models/create_ride_response.dart';
import '../models/direction.dart';
import '../models/ride_for_passenger.dart';
import '../models/ride_for_passenger_response.dart';
import '../service/map_service_impl.dart';

class MapViewModel extends ChangeNotifier {
  late MapService _mapService;

  MapViewModel() {
    _mapService = MapServiceImpl();
  }

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
  final List<LatLng> polyLineArray = [];
  final List<RideForPassenger> availableRides = [];

  Resource<RideForPassengerResponse> findRidesResource = Resource.idle();

  Future<void> findRides({
    String? source,
    String? destination,
  }) async {
    try {
      findRidesResource = Resource.loading();
      notifyListeners();

      final RideForPassengerResponse response = await _mapService.findRides(
        source: source,
        destination: destination,
      );

      findRidesResource = Resource.success(response);
    
      if (response.data != null) {
        debugPrint(findRidesResource.modelResponse!.data!.toString());
        findRidesResource.modelResponse!.data!.forEach((value) {
          availableRides.add(value);
        });
        notifyListeners();
      }
      // rideId = findRidesResource.modelResponse!.data!.rideId.toString();
      // driverId = findRidesResource.modelResponse!.data!.driverId.toString();
      // source = findRidesResource.modelResponse!.data!.source.toString();

      // destination =
      //     findRidesResource.modelResponse!.data!.destination.toString();
      // totalDistance = findRidesResource.modelResponse!.data!.totalDistance;
      // totalFare = findRidesResource.modelResponse!.data!.totalFare;

      // rideStatus = findRidesResource.modelResponse!.data!.rideStatus.toString();
      // currentLocation =
      //     findRidesResource.modelResponse!.data!.currentLocation.toString();
      // city = findRidesResource.modelResponse!.data!.city.toString();

      // rideStartedAt =
      //     findRidesResource.modelResponse!.data!.rideStartedAt.toString();
      // rideEndedAt =
      //     findRidesResource.modelResponse!.data!.rideEndedAt.toString();
      // polygonPoints = findRidesResource.modelResponse!.data!.polygonPoints;
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

  Resource<CreateRideResponse> createRideResource = Resource.idle();

  Future<void> createRide({
    String? source,
    String? destination,
    String? currentLocation,
    num? totalDistance,
    String? city,
    List<LatLng>? polygonPoints,
  }) async {
    try {
      createRideResource = Resource.loading();
      notifyListeners();

      final CreateRideResponse response = await _mapService.createRide(
          currentLocation: currentLocation,
          source: source,
          destination: destination,
          totalDistance: totalDistance,
          city: city,
          polygonPoints: polygonPoints);

      createRideResource = Resource.success(response);

      createRideResource.modelResponse!.data!.city.toString();
      notifyListeners();
    } catch (e) {
      createRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Future<void> getDirections({
    String? source,
    String? destination,
  }) async {
    try {
      notifyListeners();

      Dio dio = Dio();
      final direction = await dio.post(
          'https://maps.googleapis.com/maps/api/directions/json?',
          queryParameters: {
            'origin': source,
            'destination': destination,
            'key': googleMapApiToken
          });

      final result = direction.data as Map<String, dynamic>;

      for (var point in Directions.fromMap(result).polylinePoints) {
        polyLineArray.add(LatLng(point.latitude, point.longitude));
      }

      createRide(
        source: '33.6618931, 73.0857944',
        destination: '33.7099656, 73.0527963',
        currentLocation: '33.6618931,73.0857944',
        totalDistance: 100,
        city: 'Islamabad',
        polygonPoints: polyLineArray,
      );

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> updateDriverLoc({
    String? rideId,
    String? currentLocation,
  }) async {
    try {
      requestRideResource = Resource.loading();
      notifyListeners();

      await _mapService.updateDriverLoc(
        rideId: rideId,
        currentLocation: currentLocation,
      );

      notifyListeners();
    } catch (e) {
      requestRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
