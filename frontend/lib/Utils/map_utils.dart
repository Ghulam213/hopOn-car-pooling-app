import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng>? convertListToListLatLng(List<List<double>>? input) {
  if (input == null) {
    return null;
  }
  return input.map((point) => LatLng(point[1], point[0])).toList();
}

List<LatLng> decodePolyline(String encoded) {
  List<LatLng> points = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return points;
}

double _degreesToRadians(degrees) {
  return degrees * math.pi / 180;
}

// calculate distance via polyline
double calculateDistance(List<LatLng> points) {
  double distance = 0.0;
  for (int i = 0; i < points.length - 1; i++) {
    LatLng point1 = points[i];
    LatLng point2 = points[i + 1];

    double earthRadius = 6371000; // in meters
    double lat1 = _degreesToRadians(point1.latitude);
    double lat2 = _degreesToRadians(point2.latitude);
    double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    double dLng = _degreesToRadians(point2.longitude - point1.longitude);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double d = earthRadius * c;

    distance += d;
  }
  return distance;
}
