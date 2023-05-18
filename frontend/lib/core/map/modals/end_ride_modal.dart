import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../auth/widgets/login_button.dart';
import '../viewmodel/map_view_model.dart';

class EndRidesModal extends StatefulWidget {
  const EndRidesModal(BuildContext context, {Key? key}) : super(key: key);

  @override
  EndRidesModalState createState() => EndRidesModalState();
}

class EndRidesModalState extends State<EndRidesModal> {
  final SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: config.uiWidthPx * 0.35,
      child: const LoginButton(
        text: "End Rides",
        isLoading: false,
      ).ripple(
        () {
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
                    if (viewModel.findRidesResource.ops ==
                        NetworkStatus.LOADING) {
                      return const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      );
                    } else {
                      if (viewModel.passengersOnCurrentRide.isNotEmpty) {
                        return Column(children: [
                          Container(
                              width: 80,
                              height: 2.875,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80)),
                                color: AppColors.PRIMARY_500,
                              )),
                          const SizedBox(height: 15),
                          Text(
                            "Current Passenger On Board",
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
                                itemCount:
                                    viewModel.passengersOnCurrentRide.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            viewModel
                                                    .passengersOnCurrentRide[
                                                        index]
                                                    .id ??
                                                'Ainne Hales',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.FONT_GRAY,
                                            ),
                                          ),
                                          LoginButton(
                                            text: 'Rider Dropped',
                                            isLoading: viewModel
                                                    .changePassengerStatusResource
                                                    .ops ==
                                                NetworkStatus.LOADING,
                                            onPress: () {
                                              viewModel.changePassengerStatus(
                                                  passengerId: viewModel
                                                      .passengersOnCurrentRide[
                                                          index]
                                                      .id,
                                                  status: 'COMPLETED',
                                                  rideId:
                                                      viewModel.createdRideId);
                                            },
                                          ),
                                        ],
                                      )
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
                          'No Passengers On-Board',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
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
        },
      ),
    );
  }
}
