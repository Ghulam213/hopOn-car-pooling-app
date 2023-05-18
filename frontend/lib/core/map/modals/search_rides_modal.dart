import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:hop_on/core/map/modals/trip_details_modal.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/textfield_icons.dart';
import '../viewmodel/map_view_model.dart';

class SearchRidesModal extends StatefulWidget {
  final Function() onRideRequest;

  const SearchRidesModal({Key? key, required this.onRideRequest})
      : super(key: key);

  @override
  SearchRidesModalState createState() => SearchRidesModalState();
}

class SearchRidesModalState extends State<SearchRidesModal> {
  final SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController currentController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final source = '';
  final destination = '';

  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = context.watch<MapViewModel>();
    return SizedBox(
      width: config.uiWidthPx * 0.8,
      child: const LoginButton(
        text: "Looking for a Ride ?",
        isLoading: false,
      ).ripple(() {
        showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.only(top: 7),
                height: config.uiHeightPx / 1.5,
                width: config.uiWidthPx * 1,
                decoration: const BoxDecoration(
                  color: AppColors.LM_BACKGROUND_BASIC,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: 80,
                            height: 2.875,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(80)),
                              color: AppColors.PRIMARY_500.withOpacity(0.5),
                            )),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: SvgPicture.asset(ImagesAsset.side,
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.PRIMARY_500,
                                        BlendMode.srcIn)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomPlaceTextWidget(
                                    hintText: "Current location",
                                    onSubmitted: (value) {},
                                    controller: currentController,
                                    prefix: const PrefixIcon1(),
                                    config: config,
                                  ),
                                  const SizedBox(height: 5.0),
                                  CustomPlaceTextWidget(
                                    hintText: "Your destination",
                                    onSubmitted: (value) {},
                                    controller: destinationController,
                                    prefix: const PrefixIcon2(),
                                    config: config,
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: SizedBox(
                                      height: config.uiHeightPx * 0.06,
                                      width: config.uiWidthPx - 100,
                                      child: LoginButton(
                                        text: 'Search',
                                        onPress: () async {
                                          var src = await Future.wait([
                                            autoCompleteSearch(
                                                currentController.text),
                                            autoCompleteSearch(
                                                destinationController.text)
                                          ]);
                                          debugPrint(src[0].toString());
                                          debugPrint(src[1].toString());
                                          if (src.isNotEmpty) {
                                            mapViewModel.findRides(
                                                src[0].toString() ??
                                                    '33.6600116,73.0833224',
                                                src[1].toString() ??
                                                    '33.6844202,73.04788479999999');
                                          }
                                          // if (!context.mounted) return;
                                          // mapViewModel.getRidePassengers(
                                          //     'fabc32ad-6adb-4213-a910-a584a19c3484');
                                          buildTripDetails(
                                              context,
                                              currentController.text,
                                              destinationController.text,
                                              widget.onRideRequest);
                              
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: SvgPicture.asset(
                            ImagesAsset.hopOn,
                            colorFilter: const ColorFilter.mode(
                                AppColors.PRIMARY_500, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 70,
                          width: config.uiWidthPx * 1,
                          decoration: const BoxDecoration(
                            color: AppColors.PRIMARY_500,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: InkWell(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(ImagesAsset.globe,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn)),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Search on Map",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                    )
                                  ]),
                              onTap: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      }),
    );
  }
}
