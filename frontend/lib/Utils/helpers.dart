import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  return LatLng(sharedPreferences.getDouble('latitude') ?? 23.3,
      sharedPreferences.getDouble('longitude') ?? 70.3);
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

// Map getGeometryFromSharedPrefs(int index) {
//   Map geometry =  {}//getDecodedResponseFromSharedPrefs(index)['geometry'];
//   return geometry;
// }
