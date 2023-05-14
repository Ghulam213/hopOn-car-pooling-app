import 'dart:developer';

import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hop_on/Utils/constants.dart';
import 'package:hop_on/Utils/helpers.dart';

import '../../../Utils/map_utils.dart';
import '../../../config/network/resources.dart';
import '../domain/map_service.dart';
import '../models/create_ride_response.dart';
import '../models/direction.dart';
import '../models/driver_response_general.dart';
import '../models/get_ride_location_response.dart';
import '../models/request_ride_response.dart';
import '../models/ride_for_passenger.dart';
import '../models/ride_for_passenger_response.dart';
import '../service/map_service_impl.dart';

class MapViewModel extends ChangeNotifier {
  late MapService _mapService;

  MapViewModel() {
    _mapService = MapServiceImpl();
    getCurrentLocation().then((value) => currentLocation = value);
  }

  final cron = Cron();

  String createdRideId = '';
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

  // for passenger mode
  bool hasDriverAcceptedPassengerRideRequest = false;

  Rider? rideDriver = Rider();
  List<Rider?> ridePassengers = [];

  List<LatLng> _polyLineArray = [];
  final List<RideForPassenger> _availableRides = [];

  List<LatLng> get polyLineArray => _polyLineArray;
  List<RideForPassenger> get availableRides => _availableRides;

  Future<void> cronUpdateDriverLoc() async {
    var currentLoc = await getCurrentLocation();
    // */1 * * * * means every minute
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      updateDriverLoc(currentLocation: currentLoc, rideId: createdRideId);
      logger('###  Driver Location CRON task called  with ID: $createdRideId ###');
    });
  }

  Future<void> cronUpdatePassengerLoc() async {
    var currentLoc = await getCurrentLocation();
    // */1 * * * * means every minute
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      updatePassengerLoc(rideId: rideId, currentLocation: currentLoc);
      logger('###  Passenger Location CRON task called with ID: $createdRideId ###');
    });
  }

  Future<void> cronGetRideLoc() async {
    // */1 * * * * means every minute
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      getRideLocation(createdRideId.isNotEmpty ? createdRideId : rideId);
      logger('### Get Ride Location CRON task called with ID: $createdRideId ###');
    });
  }

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
        _availableRides.removeWhere((RideForPassenger datum) {
          return _availableRides.contains(datum);
        });

        for (var datum in findRidesResource.modelResponse!.data!) {
          _availableRides.add(datum);

          log(datum.id.toString());
        }

        for (var datum in _availableRides) {
          {
            var src = await Future.wait([
              placemarkFromCoordinates(
                  double.parse(datum.source!.split(',')[0]), double.parse(datum.source!.split(',')[1])),
              placemarkFromCoordinates(
                  double.parse(datum.destination!.split(',')[0]), double.parse(datum.destination!.split(',')[1]))
            ]);

            datum.source = src[0].map((placemark) => placemark.name).toString();
            datum.destination = src[1].map((placemark) => placemark.name).toString();
          }
        }
        debugPrint("Available Rides${_availableRides.toString()}");
        notifyListeners();
      }
      currentLocation = await getCurrentLocation();
    } catch (e) {
      findRidesResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<RequestRideResponse> requestRideResource = Resource.idle();

  Future<void> requestRide({
    required String? rideId,
    required String? passengerSource,
    required String? passengerDestination,
    required String? driverName,
    required num? distance,
    required num? fare,
    required num? ETA,
  }) async {
    try {
      requestRideResource = Resource.loading();
      notifyListeners();

      hasDriverAcceptedPassengerRideRequest = false;

      final RequestRideResponse response = await _mapService.requestRide(
        rideId: rideId,
        passengerSource: passengerSource,
        passengerDestination: passengerDestination,
        driverName: driverName,
        distance: distance,
        fare: fare,
        ETA: ETA,
      );

      requestRideResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      requestRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<CreatedRideResponse> createRideResource = Resource.idle();

  Future<void> createRide({
    String? source,
    String? destination,
    String? currentLocation,
    num? totalDistance,
    String? city,
  }) async {
    try {
      createRideResource = Resource.loading();
      notifyListeners();

      await getDirections(
        source: source,
        destination: destination,
      );

      final CreatedRideResponse response = await _mapService.createRide(
        currentLocation: currentLocation,
        source: source,
        destination: destination,
        totalDistance: totalDistance,
        city: city,
        polygonPoints: polyLineArray,
      );

      createRideResource = Resource.success(response);

      createdRideId = createRideResource.modelResponse!.data!.id.toString();

      cronUpdateDriverLoc();
      cronGetRideLoc();
      rideDriver = Rider(id: createRideResource.modelResponse!.data!.driverId, currentLocation: source);
      this.currentLocation = currentLocation ?? await getCurrentLocation();

      notifyListeners();
    } catch (e) {
      createRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<void> acceptRideResource = Resource.idle();

  Future<void> acceptRide({
    required String? rideId,
    required String? passengerSource,
    required String? passengerDestination,
    required String? driverName,
    required num? distance,
    required num? fare,
    required num? ETA,
  }) async {
    try {
      acceptRideResource = Resource.loading();
      notifyListeners();

      await _mapService.acceptRide(
        rideId: rideId,
        passengerSource: passengerSource,
        passengerDestination: passengerDestination,
        driverName: driverName,
        distance: distance,
        fare: fare,
        ETA: ETA,
      );

      notifyListeners();
    } catch (e) {
      acceptRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<void> rejectRideResource = Resource.idle();

  Future<void> rejectRide({
    required String? rideId,
    required String? passengerSource,
    required String? passengerDestination,
    required String? driverName,
    required num? distance,
    required num? fare,
    required num? ETA,
  }) async {
    try {
      rejectRideResource = Resource.loading();
      notifyListeners();

      await _mapService.acceptRide(
        rideId: rideId,
        passengerSource: passengerSource,
        passengerDestination: passengerDestination,
        driverName: driverName,
        distance: distance,
        fare: fare,
        ETA: ETA,
      );

      notifyListeners();
    } catch (e) {
      rejectRideResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<void> updateDriverLocResource = Resource.idle();

  Future<void> updateDriverLoc({
    String? rideId,
    String? currentLocation,
  }) async {
    try {
      updateDriverLocResource = Resource.loading();
      notifyListeners();

      await _mapService.updateDriverLoc(
        rideId: rideId,
        currentLocation: currentLocation,
      );

      notifyListeners();
    } catch (e) {
      updateDriverLocResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<void> updatePassengerLocResource = Resource.idle();

  Future<void> updatePassengerLoc({
    String? rideId,
    String? currentLocation,
  }) async {
    try {
      updatePassengerLocResource = Resource.loading();
      notifyListeners();

      await _mapService.updatePassengerLoc(
        rideId: rideId,
        currentLocation: currentLocation,
      );

      notifyListeners();
    } catch (e) {
      updatePassengerLocResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<GetRideResponse> getRideLocationResource = Resource.idle();

  Future<void> getRideLocation(
    String rideId,
  ) async {
    try {
      getRideLocationResource = Resource.loading();
      notifyListeners();

      final GetRideResponse response = await _mapService.getRideLocation(rideId);

      getRideLocationResource = Resource.success(response);

      rideDriver = getRideLocationResource.modelResponse?.data?.driver;
      ridePassengers = getRideLocationResource.modelResponse?.data?.passengers ?? ridePassengers;
      currentLocation = await getCurrentLocation();

      // shall be giving live location of driver
      // Done : Update the map marketr using updateMarker() func and polyline (drawRoute func) with live driver/passengers location
      // Need a way to listen to rideDriver.currentLocation either via Consumer<MapViewModel> (see other places where used) or some other way

      notifyListeners();
    } catch (e) {
      getRideLocationResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Future<void> getDirections({
    String? source,
    String? destination,
  }) async {
    try {
      Dio dio = Dio();
      final direction = await dio.post(
        'https://maps.googleapis.com/maps/api/directions/json?',
        queryParameters: {'origin': source, 'destination': destination, 'key': googleMapApiToken},
      );

      final Directions directionResponse = Directions.fromJson(direction.data as Map<String, dynamic>);

      _polyLineArray = decodePolyline(directionResponse.routes?[0].overviewPolyline?.points as String);

      // final result = direction.data as Map<String, dynamic>;
      // List<LatLng> tempPolyLine = [];
      // for (var point in Directions.fromMap(result).polylinePoints) {
      //   log('points ${point.latitude},${point.longitude}');
      //   tempPolyLine.add(LatLng(point.latitude, point.longitude));
      // }
      // _polyLineArray = tempPolyLine;

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Resource<DriverGeneralResponse> rideCompletedResource = Resource.idle();

  Future<void> rideCompleted({
    required String rideId,
  }) async {
    try {
      rideCompletedResource = Resource.loading();
      notifyListeners();

      await _mapService.rideCompleted(
        rideId,
      );

      notifyListeners();
    } catch (e) {
      rideCompletedResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<DriverGeneralResponse> changePassengerStatusResource = Resource.idle();

  Future<void> changePassengerStatus({
    required rideId,
    required status,
  }) async {
    try {
      changePassengerStatusResource = Resource.loading();
      notifyListeners();

      await _mapService.changePassengerStatus(
        rideId,
        status,
      );

      notifyListeners();
    } catch (e) {
      changePassengerStatusResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
