import 'package:flutter/material.dart';
import 'package:hop_on/core/map/models/ride_mock_data.dart';
import 'package:hop_on/core/map/widgets/ride_card.dart';

import '../../../config/sizeconfig/size_config.dart';

class RideDetails extends StatefulWidget {
  const RideDetails({Key? key}) : super(key: key);

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  final SizeConfig _config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 250,
      width: _config.uiWidthPx * 1,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: RideData.rideDetails
            .map((rideDetails) => RideCard(
                rideModel: rideDetails,
                onSelected: (model) {
                  setState(() {
                    RideData.rideDetails.forEach((item) {
                      item.isSelected = false;
                    });
                    model.isSelected = true;
                  });
                }))
            .toList(),
      ),
    );
  }
}
