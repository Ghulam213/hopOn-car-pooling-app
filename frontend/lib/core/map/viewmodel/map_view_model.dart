import 'package:flutter/material.dart';
import 'package:hop_on/core/map/models/map_response.dart';

import '../../../config/network/resources.dart';
import '../domain/map_service.dart';
import '../service/map_service_impl.dart';

class MapViewModel extends ChangeNotifier {
  late MapService _mapService;

  MapViewModel() {
    _mapService = MapServiceImpl();
  }

  Resource<MapResponse> findRidesResource = Resource.idle();

  // String polygonPoints = '';
  // String destination = '';
  // String cnicBack = '';
  // String cnicFront = '';

  Future<void> getDriver({
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

      debugPrint('getDriver');
      debugPrint(response.toString());
      findRidesResource = Resource.success(response);

      // active = findRidesResource.modelResponse!.data!.active.toString();
      // cnicBack = findRidesResource.modelResponse!.data!.cnicBack.toString();
      // cnicFront = findRidesResource.modelResponse!.data!.cnicFront.toString();
      // licenseBack =
      //     findRidesResource.modelResponse!.data!.licenseBack.toString();

      notifyListeners();
    } catch (e) {
      findRidesResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<MapResponse> requestRideResource = Resource.idle();

  Future<void> requestRide({
    required String? rideId,
    required String? passengerId,
    required String? source,
    required String? destination,
    required num? distance,
  }) async {
    try {
      requestRideResource = Resource.loading();
      notifyListeners();

      final MapResponse response = await _mapService.requestRide(
        rideId: rideId,
        passengerId: passengerId,
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
