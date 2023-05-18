import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class GlobalVariable {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}

getSharedPrefs(String key) async {
  final value = sharedPreferences.getInt(key) ?? '';
  return value;
}

void setSharedPrefs(String key, String value) async {
  await sharedPreferences.setString(key, value);
}

LatLng getLatLngFromSharedPrefs() {
  return const LatLng(33.6844, 73.0479);

  // TO DO: REPLACE WHEN TESTING ON REAL DEVICE
  // return LatLng(
  //     double.parse(sharedPreferences.getString('latitude') ?? '33.6844'),
  //     double.parse(sharedPreferences.getString('longitude') ?? '73.0479'));
}

num getDistanceFromSharedPrefs(int index) {
  num distance = 2000; //getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = 100; //getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed, {BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                )),
                onPressed: () {
                  onPressed();
                },
                child: Container()),
          )
        ],
      );
}

bool isCoordinateInIslamabad(String coordinate) {
  double latitude, longitude;

  // Split the coordinate string into latitude and longitude
  List<String> parts = coordinate.split(',');

  if (parts.length != 2) {
    throw const FormatException('Invalid coordinate format. Expected "latitude,longitude".');
  }

  // Parse latitude and longitude values
  try {
    latitude = double.parse(parts[0]);
    longitude = double.parse(parts[1]);
  } catch (e) {
    throw const FormatException('Invalid coordinate values. Latitude and longitude must be numeric.');
  }

  // Define the boundary coordinates for Islamabad
  double islamabadMinLatitude = 33.5;
  double islamabadMaxLatitude = 34.1;
  double islamabadMinLongitude = 72.6;
  double islamabadMaxLongitude = 73.4;

  // Check if the coordinate is within Islamabad
  if (latitude >= islamabadMinLatitude &&
      latitude <= islamabadMaxLatitude &&
      longitude >= islamabadMinLongitude &&
      longitude <= islamabadMaxLongitude) {
    return true;
  }

  return false;
}

Future<String> getCurrentLocation() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool isDriver = sharedPreferences.getString("userMode") == "DRIVER";
  var location = loc.Location();
  var locationService = await location.getLocation();

  String currentLocationFromMob = "${locationService.latitude},${locationService.longitude}";

  if (isCoordinateInIslamabad(currentLocationFromMob)) {
    log('currentLocationFromMob: $currentLocationFromMob');
    return currentLocationFromMob;
  } else {
    return isDriver ? '33.6600116,73.0833224' : '33.66085,73.08258';
  }
}

void logger(String? message) {
  // ignore: avoid_print
  kDebugMode ? print(('$message')) : log('$message');
}

Future<String?> autoCompleteSearch(String value) async {
  if (value != '') {
    try {
      List<Location> locations = await locationFromAddress(value);

      return '${locations[0].latitude.toString()},${locations[0].longitude.toString()}';
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  return null;
}

LatLng? convertStringToLatLng(String? latLngString) {
  if (latLngString == null) {
    return null;
  }
  List<String> latLngList = latLngString.split(',');
  if (latLngList.length != 2) {
    return null;
  }
  double? latitude = double.tryParse(latLngList[0].trim());
  double? longitude = double.tryParse(latLngList[1].trim());
  if (latitude == null || longitude == null) {
    return null;
  }
  return LatLng(latitude, longitude);
}

// Map getGeometryFromSharedPrefs(int index) {
//   Map geometry =  {}//getDecodedResponseFromSharedPrefs(index)['geometry'];
//   return geometry;
// }
