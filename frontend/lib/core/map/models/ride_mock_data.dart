import 'package:flutter/material.dart';
import 'package:hop_on/core/map/models/ride.dart';

import '../../../Utils/image_path.dart';

// class RideModel {
//   int id;
//   String name;
//   String image;
//   String price;
//   String time;
//   bool isSelected;

//   RideModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.price,
//     required this.time,
//     this.isSelected = false,
//   });
// }

class RideData {
  static List<Ride> rideDetails = <Ride>[
    Ride(
      source: "Umer Zia",
      totalFare: 3000,
      rideStartedAt: "09: 38 am",
      rideId: '1',
    ),
    Ride(
      source: "Rydr Regular",
      totalFare: 5000,
      rideStartedAt: "10: 45 am",
      rideId: '2',
    ),
  ];
}
