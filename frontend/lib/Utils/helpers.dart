import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';
import 'constants.dart';

class GlobalVariable {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
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

LatLng getLatLngFromRestaurantData(int index) {
  return LatLng(double.parse(restaurants[index]['coordinates']['latitude']),
      double.parse(restaurants[index]['coordinates']['longitude']));
}

// Map getDecodedResponseFromSharedPrefs(int index) {
//   String key = 'restaurant--$index';
//   Map response = json.decode(sharedPreferences.getString(key)!);
//   return response;
// }

num getDistanceFromSharedPrefs(int index) {
  num distance = 2000; //getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = 100; //getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

List<LatLng>? convertListToListLatLng(List<List<double>>? input) {
  if (input == null) {
    return null;
  }
  return input.map((point) => LatLng(point[1], point[0])).toList();
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
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

void logger(String? message) {
  // ignore: avoid_print
  kDebugMode ? print(('$message')) : log('$message');
}


// Map getGeometryFromSharedPrefs(int index) {
//   Map geometry =  {}//getDecodedResponseFromSharedPrefs(index)['geometry'];
//   return geometry;
// }
