import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../viewmodel/map_view_model.dart';
import '../widgets/ride_details.dart';
import 'confirm_trip_modal.dart';

buildTripDetails(BuildContext context, String source, String destination) {
  final SizeConfig _config = SizeConfig();

  final MapViewModel mapViewModel =
      Provider.of<MapViewModel>(context, listen: false);

  Navigator.pop(context);
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 7),
          height: _config.uiHeightPx / 2.5,
          width: _config.uiWidthPx * 1,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Container(
            child: Column(
              children: [
                Container(
                    width: 80,
                    height: 2.875,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                      color: AppColors.PRIMARY_500,
                    )),
                const SizedBox(height: 15),
                Text(
                  "Trip Details",
                  style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.FONT_GRAY,
                  ),
        
                ),
                const SizedBox(height: 10),
                const DotWidget(
                  dashColor: AppColors.LM_SEPARATOR_GREY1,
                  dashHeight: 1.0,
                  dashWidth: 2.0,
                ),
                const SizedBox(height: 10),
                tripdetails(
                  ImagesAsset.down,
                  "Your Current Location",
                  "Ilorin, Kwara State",
                  "Estimated Distance",
                  ImagesAsset.run,
                  "Distance: 2.12 km",
                ),
                const SizedBox(height: 15),
                const DotWidget(
                  dashColor: AppColors.LM_SEPARATOR_GREY1,
                  dashHeight: 1.0,
                  dashWidth: 2.0,
                ),
                const SizedBox(height: 15),
                tripdetails(
                  ImagesAsset.locate,
                  "Your Destination",
                  "Ilorin, Kwara State",
                  "Estimated time",
                  ImagesAsset.clock,
                  "4 munites 42 secs",
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    height: 50,
                    width: _config.uiWidthPx * 1,
                    child: LoginButton(
                      text: "Confirm",
                      // onPress: () {
                      //   // TO DO:  Update from real values
                      //   mapViewModel.findRides(
                      //       source: '72.988149,33.642838',
                      //       destination: '73.087289,33.664512');
                      // }

                      onPress: () {
                        mapViewModel.findRides(
                            source: '72.988149,33.642838',
                            destination: '73.087289,33.664512');
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isDismissible: false,
                            isScrollControlled: true,
                            elevation: 0,
                            backgroundColor: Colors.white,
                            clipBehavior: Clip.hardEdge,
                            context: context,
                            builder: (context) {
                              return Container(
                                padding:
                                    const EdgeInsets.only(top: 7, bottom: 10),
                                height: _config.uiHeightPx / 2,
                                width: _config.uiWidthPx * 1,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 80,
                                          height: 2.875,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(80)),
                                            color: AppColors.PRIMARY_500,
                                          )),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Select a ride",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.PRIMARY_500,
                                        ),
                                      ),
                                      DotWidget(
                                        dashColor: AppColors.PRIMARY_500,
                                        dashHeight: 1.0,
                                        dashWidth: 2.0,
                                      ),
                                      const SizedBox(height: 10),
                                      RideDetails(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: Container(
                                          height: 40,
                                          width: _config.uiWidthPx * 1,
                                          decoration: BoxDecoration(
                                            color: AppColors.PRIMARY_500
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              buildConfirmTrip(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Book Rydr",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Widget tripdetails(
  String icon,
  String locate,
  String location,
  String extimated,
  String eIcon,
  String eDistance,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(icon),
              ],
            ),
            SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locate,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  location,
                  style: GoogleFonts.montserrat(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF818181),
                  ),
                )
              ],
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              extimated,
              style: GoogleFonts.montserrat(
                fontSize: 9.0,
                fontWeight: FontWeight.w300,
                color: Color(0xFF818181),
              ),
            ),
            const SizedBox(height: 2.0),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.FONT_GRAY,
                  borderRadius: BorderRadius.circular(7.0)),
              child: Row(
                children: [
                  SvgPicture.asset(
                    eIcon,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    eDistance,
                    style: GoogleFonts.montserrat(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.PRIMARY_500,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}

class DotWidget extends StatelessWidget {
  final double totalWidth, dashWidth, emptyWidth, dashHeight;

  final Color dashColor;

  const DotWidget({
    this.totalWidth = 300,
    this.dashWidth = 10,
    this.emptyWidth = 5,
    this.dashHeight = 2,
    this.dashColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalWidth ~/ (dashWidth + emptyWidth),
        (_) => Container(
          width: dashWidth,
          height: dashHeight,
          color: dashColor,
          margin: EdgeInsets.only(left: emptyWidth / 2, right: emptyWidth / 2),
        ),
      ),
    );
  }
}
