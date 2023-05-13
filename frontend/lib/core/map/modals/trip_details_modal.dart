import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/core/map/modals/confirm_trip_modal.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../auth/widgets/login_button.dart';
import '../../widgets/dot_widget.dart';
import '../viewmodel/map_view_model.dart';

buildTripDetails(BuildContext context, String source, String destination, Function onRideRequest) {
  final SizeConfig config = SizeConfig();

  Navigator.pop(context);
  showModalBottomSheet(
    isDismissible: true,
    isScrollControlled: true,
    elevation: 5,
    backgroundColor: Colors.white,
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.only(top: 7),
        height: config.uiHeightPx / 2,
        width: config.uiWidthPx * 1,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Consumer<MapViewModel>(
          builder: (BuildContext context, MapViewModel viewModel, _) {
            if (viewModel.findRidesResource.ops == NetworkStatus.LOADING) {
              return const Center(
                child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
              );
            } else {
              if (viewModel.availableRides.isNotEmpty) {
                return Column(children: [
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
                  SingleChildScrollView(
                    child: SizedBox(
                      height: config.uiHeightPx * 0.36,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        dragStartBehavior: DragStartBehavior.down,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: viewModel.availableRides.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              tripdetails(
                                  ImagesAsset.down,
                                  "Your Current Location",
                                  viewModel.availableRides[index].source.toString(),
                                  "Estimated Distance",
                                  ImagesAsset.run,
                                  viewModel.availableRides[index].ETA.toString(),
                                  config),
                              const SizedBox(height: 10),
                              tripdetails(
                                  ImagesAsset.locate,
                                  "Your Destination",
                                  viewModel.availableRides[index].destination.toString(),
                                  "Estimated time",
                                  ImagesAsset.clock,
                                  viewModel.availableRides[index].ETA.toString(),
                                  config),
                              const SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: config.uiWidthPx * 0.2),
                                child: SizedBox(
                                  height: 40,
                                  width: config.uiWidthPx * 1,
                                  child: LoginButton(
                                    text: "Select",
                                    onPress: () {
                                      Future.delayed(const Duration(milliseconds: 1), () {
                                        Navigator.pop(context);
                                        viewModel.requestRide(
                                          rideId: viewModel.availableRides[index].id,
                                          distance: index == 0 ? 20 : 30, // TO DO : get from google map
                                          driverName: viewModel.availableRides[index].driverName,
                                          passengerSource: viewModel.availableRides[index].source,
                                          passengerDestination: viewModel.availableRides[index].destination,
                                          fare: viewModel.availableRides[index].fare,
                                          ETA: viewModel.availableRides[index].ETA,
                                        );
                                        buildConfirmTrip(context, index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const DotWidget(
                                dashColor: AppColors.PRIMARY_500,
                                dashHeight: 1.0,
                                dashWidth: 2.0,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ]);
              } else {
                return Center(
                    child: Text(
                  'No Rides Found',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.PRIMARY_500,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                ));
              }
            }
          },
        ),
      );
    },
  );
}

// Future<dynamic> showSelectRideModal(BuildContext context, SizeConfig config,
//     MapViewModel viewModel, int index) {
//   return showModalBottomSheet(
//       isDismissible: false,
//       isScrollControlled: true,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       clipBehavior: Clip.hardEdge,
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.only(top: 7, bottom: 10),
//           height: config.uiHeightPx / 1.5,
//           width: config.uiWidthPx * 1,
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15),
//               topRight: Radius.circular(15),
//             ),
//           ),
//           child: Column(
//             children: [
//               Container(
//                   width: 80,
//                   height: 2.875,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(80)),
//                     color: AppColors.PRIMARY_500,
//                   )),
//               const SizedBox(height: 15),
//               Text(
//                 "Select a driver",
//                 style: GoogleFonts.montserrat(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.PRIMARY_500,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               const DotWidget(
//                 dashColor: AppColors.PRIMARY_500,
//                 dashHeight: 1.0,
//                 dashWidth: 2.0,
//               ),
//               const SizedBox(height: 10),
//               RideCard(index: index),
//               const Spacer(),
//             ],
//           ),
//         );
//       });
// }

Widget tripdetails(
    String icon, String locate, String location, String extimated, String eIcon, String eDistance, SizeConfig config) {
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
                SvgPicture.asset(icon, colorFilter: const ColorFilter.mode(AppColors.PRIMARY_500, BlendMode.srcIn)),
              ],
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: config.uiWidthPx * 0.5,
                  child: AutoSizeText(
                    locate,
                    maxLines: 1,
                    minFontSize: 9,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.PRIMARY_500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: config.uiWidthPx * 0.5,
                  child: AutoSizeText(
                    location,
                    maxLines: 1,
                    minFontSize: 9,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF818181),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              extimated,
              style: GoogleFonts.montserrat(
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF818181),
              ),
            ),
            const SizedBox(height: 2.0),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.PRIMARY_500.withOpacity(0.2), borderRadius: BorderRadius.circular(7.0)),
              child: Row(
                children: [
                  SvgPicture.asset(eIcon,
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(AppColors.PRIMARY_500, BlendMode.srcIn)),
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
