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
import '../models/get_ride_passengers_response.dart';
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

  final List<GetRidePassengers> _passengersOnCurrentRide = [];

  List<LatLng> _polyLineArray = [];
  final List<RideForPassenger> _availableRides = [];

  List<GetRidePassengers> get passengersOnCurrentRide =>
      _passengersOnCurrentRide;
  List<LatLng> get polyLineArray => _polyLineArray;
  List<RideForPassenger> get availableRides => _availableRides;

  Future<void> cronUpdateDriverLoc() async {
    var currentLoc = await getCurrentLocation();
    // */1 * * * * means every minute
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      updateDriverLoc(
          currentLocation: '33.6600116,73.0833224', rideId: createdRideId);
      logger(
          '###  Driver Location CRON task called  with ID: $createdRideId ###');
    });
  }

  Future<void> cronUpdatePassengerLoc() async {
    var currentLoc = await getCurrentLocation();
    // */1 * * * * means every minute
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      updatePassengerLoc(
          rideId: rideId, currentLocation: '33.6600116,73.0833224');
      logger(
          '###  Passenger Location CRON task called with ID: $createdRideId ###');
    });
  }

  Future<void> cronGetRideLoc() async {
    // */1 * * * * means every minute
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      getRideLocation(createdRideId.isNotEmpty ? createdRideId : rideId);
      logger(
          '### Get Ride Location CRON task called with ID: $createdRideId ###');
    });
  }

  Resource<RideForPassengerResponse> findRidesResource = Resource.idle();

  Future<void> findRides(
    String source,
    String destination,
  ) async {
    try {
      findRidesResource = Resource.loading();
      notifyListeners();

      var mapRes = await getDirectionApi(source, destination);

      final Directions directionResponse =
          Directions.fromJson(mapRes.data as Map<String, dynamic>);

      var polylineArr = decodePolyline(
          directionResponse.routes?[0].overviewPolyline?.points as String);
      final RideForPassengerResponse response = await _mapService.findRides(
          source: source,
          destination: destination,
          distance: calculateDistance(polylineArr) / 1000);

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
                  double.parse(datum.source!.split(',')[0]),
                  double.parse(datum.source!.split(',')[1])),
              placemarkFromCoordinates(
                  double.parse(datum.destination!.split(',')[0]),
                  double.parse(datum.destination!.split(',')[1]))
            ]);

            datum.source = src[0].map((placemark) => placemark.name).toString();
            datum.destination =
                src[1].map((placemark) => placemark.name).toString();
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
        source,
        destination,
      );

      final CreatedRideResponse response = await _mapService.createRide(
        currentLocation: '33.6600116,73.0833224',
        source: source,
        destination: destination,
        totalDistance: totalDistance,
        city: city,
        polygonPoints: polyLineArray,
      );

      Future.delayed(const Duration(seconds: 1), () {
        createRideResource = Resource.success(response);
        notifyListeners();
      });


      createdRideId = createRideResource.modelResponse!.data!.id.toString();
     

      cronUpdateDriverLoc();
      cronGetRideLoc();
      rideDriver = Rider(
          id: createRideResource.modelResponse!.data!.driverId,
          currentLocation: source);
      this.currentLocation =
          '33.6600116,73.0833224' ?? await getCurrentLocation();

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
        currentLocation: '33.6600116,73.0833224',
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
        currentLocation: '33.6600116,73.0833224',
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

      final GetRideResponse response =
          await _mapService.getRideLocation(rideId);

      getRideLocationResource = Resource.success(response);

      rideDriver = getRideLocationResource.modelResponse?.data?.driver;
      ridePassengers =
          getRideLocationResource.modelResponse?.data?.passengers ??
              ridePassengers;
      currentLocation = await getCurrentLocation();

      logger(rideDriver?.currentLocation.toString());
      notifyListeners();
    } catch (e) {
      getRideLocationResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<GetRidePassengersResponse> getRidePassengersResource =
      Resource.idle();

  Future<void> getRidePassengers(
    String rideId,
  ) async {
    try {
      getRidePassengersResource = Resource.loading();
      notifyListeners();

      final GetRidePassengersResponse response =
          await _mapService.getRidePassengers(rideId);

      getRidePassengersResource = Resource.success(response);

      for (var datum in getRidePassengersResource.modelResponse!.data!) {
        _passengersOnCurrentRide.add(datum);
      }

      logger(_passengersOnCurrentRide.toString());
      notifyListeners();
    } catch (e) {
      getRidePassengersResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Future<Response<dynamic>> getDirectionApi(String src, String dest) async {
    Dio dio = Dio();
    return await dio.post(
        'https://maps.googleapis.com/maps/api/directions/json?',
        queryParameters: {
          'origin': src,
          'destination': dest,
          'key': googleMapApiToken
        });
  }

  Future<void> getDirections(
    String? source,
    String? destination,
  ) async {
    var currentLoc = await getCurrentLocation();
    try {
      final direction = await getDirectionApi(source!, destination!);

      final Directions directionResponse =
          Directions.fromJson(direction.data as Map<String, dynamic>);

      _polyLineArray = decodePolyline(
          directionResponse.routes?[0].overviewPolyline?.points as String);

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

  Resource<DriverGeneralResponse> changePassengerStatusResource =
      Resource.idle();

  Future<void> changePassengerStatus({
    required rideId,
    passengerId,
    required status,
  }) async {
    try {
      changePassengerStatusResource = Resource.loading();
      notifyListeners();

      await _mapService.changePassengerStatus(
        rideId,
        passengerId,
        status,
      );

      notifyListeners();
    } catch (e) {
      changePassengerStatusResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
