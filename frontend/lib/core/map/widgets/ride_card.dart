import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/Utils/helpers.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../modals/confirm_trip_modal.dart';
import '../models/ride.dart';
import '../models/ride_mock_data.dart';

class RideCard extends StatefulWidget {
  final Ride rideModel;
  final ValueChanged<Ride> onSelected;

  const RideCard({
    required this.rideModel,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  _RideCardState createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        debugPrint(isSelected.toString());
        setState(() {
          isSelected = !isSelected;
        });
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
                        widget.rideModel.rideStartedAt.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : AppColors.PRIMARY_500,
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        color: isSelected
                            ? Colors.white
                            : AppColors.PRIMARY_500,
                        size: 8,
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImagesAsset.time,
                        color: isSelected
                            ? Colors.white
                            : AppColors.PRIMARY_500,
                        height: 8,
                        width: 8,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "12 mins",
                        style: GoogleFonts.montserrat(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w300,
                          color: isSelected
                              ? Colors.white
                              : AppColors.PRIMARY_500,
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
                            "3 seats",
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
                  SizedBox(height: 5),
                 
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "\Rs. " + widget.rideModel.totalFare.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white
                          : AppColors.PRIMARY_500,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.rideModel.destination.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 9.0,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.PRIMARY_500,
                    ),
                  ),

                
                ],
              ),
            ),
          ],
        ),
      ).ripple(() {
        setState(() {
          widget.onSelected(widget.rideModel);
        });
      }),
    );
  }
}