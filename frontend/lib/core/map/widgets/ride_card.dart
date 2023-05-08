import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/map/viewmodel/map_view_model.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../modals/confirm_trip_modal.dart';

class RideCard extends StatefulWidget {
  final int index;

  const RideCard({
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  RideCardState createState() => RideCardState();
}

// TO DO : Replace with enjoyRideModal design
class RideCardState extends State<RideCard> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    final MapViewModel viewModel = context.watch<MapViewModel>();

    return InkWell(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
        });

        viewModel.requestRide(
          rideId: viewModel.availableRides[widget.index].id,
          distance: widget.index == 0 ? 20 : 30, // TO DO : get from google map
          driverName: viewModel.availableRides[widget.index].driverName,
          passengerSource: viewModel.availableRides[widget.index].source,
          passengerDestination:
              viewModel.availableRides[widget.index].destination,
          fare: viewModel.availableRides[widget.index].fare,
          ETA: viewModel.availableRides[widget.index].ETA,
        );
        buildConfirmTrip(context);
      },
      child: Container(
        color: isSelected
            ? AppColors.PRIMARY_500.withOpacity(0.8)
            : Colors.white.withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.availableRides[widget.index].driverName
                            .toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color:
                              isSelected ? Colors.white : AppColors.PRIMARY_500,
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        color:
                            isSelected ? Colors.white : AppColors.PRIMARY_500,
                        size: 8,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImagesAsset.time,
                        color:
                            isSelected ? Colors.white : AppColors.PRIMARY_500,
                        height: 8,
                        width: 8,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        viewModel.availableRides[widget.index].ETA.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          color:
                              isSelected ? Colors.white : AppColors.PRIMARY_500,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: isSelected
                                ? Colors.white
                                : AppColors.PRIMARY_500,
                            size: 10,
                          ),
                          Text(
                            viewModel.availableRides[widget.index]
                                .alreadySeatedPassengerCount
                                .toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w300,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.PRIMARY_500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Rs. ${viewModel.availableRides[widget.index].fare.toString()}",
                    style: GoogleFonts.montserrat(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.PRIMARY_500,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    viewModel.availableRides[widget.index].destination
                        .toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 9.0,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.PRIMARY_500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).ripple(() {}),
    );
  }
}
