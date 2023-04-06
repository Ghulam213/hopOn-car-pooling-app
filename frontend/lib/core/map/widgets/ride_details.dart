import 'package:flutter/material.dart';
import 'package:hop_on/core/map/models/ride_mock_data.dart';
import 'package:hop_on/core/map/widgets/ride_card.dart';
import 'package:provider/provider.dart';

import '../../../config/sizeconfig/size_config.dart';
import '../models/ride.dart';
import '../viewmodel/map_view_model.dart';

class RideDetails extends StatefulWidget {



  const RideDetails({Key? key}) : super(key: key);

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  final SizeConfig _config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = context.watch<MapViewModel>();

    final bool isSelected;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 250,
      width: _config.uiWidthPx * 1,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: RideData.rideDetails
            .map((rideDetails) =>
                RideCard(rideModel: rideDetails, onSelected: (model) {}))
            .toList(),
      ),

      //  ListView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   scrollDirection: Axis.vertical,
      //   children: List.generate(mapViewModel.availableRides.length, (index) {
      //     final Ride data = mapViewModel.availableRides[index];
      //     return RideCard(
      //         rideModel: data,
      //         onSelected: (model) {
      //           onRideRequest();
                // setState(() {
                //   mapViewModel.availableRides.forEach((item) {
                //     item.isSelected = false;
                //   });
                //   model.isSelected = true;
                // });
      //         });
      //     ;
      //   }),
      //   // mapViewModel.availableRides
      //   //     .map((rideDetails) => RideCard(
      //   //           rideModel: Ride,
      //   //           onSelected: (MapViewModel mapViewModel) {},
      //   //           // onSelected: (model) {
      //   //           //   setState(() {
      //   //           //     Ride.rideDetails.forEach((item) {
      //   //           //      item.isSelected = false;
      //   //           //     });
      //   //           //  model.isSelected = true;
      //   //           //   });
      //   //           // }
      //   //         ))
      //   //     .toList(),
      // ),
    );
  }
}
