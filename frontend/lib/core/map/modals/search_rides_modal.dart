import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:hop_on/core/map/modals/trip_details_modal.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/textfield_icons.dart';

class SearchRidesModal extends StatefulWidget {
  final Function() onCloseTap;
  final Function(String) onErrorOccurred;
  final Function() onRideRequest;

  const SearchRidesModal(
      {Key? key,
      required this.onCloseTap,
      required this.onErrorOccurred,
      required this.onRideRequest})
      : super(key: key);

  @override
  _SearchRidesModalState createState() => _SearchRidesModalState();
}

class _SearchRidesModalState extends State<SearchRidesModal> {
  final SizeConfig _config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController currentController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  Timer? _debounce;

  void autoCompleteSearch(String value) async {
    GeoCode geoCode = GeoCode(apiKey: "126435123870473308801x22127");

    Coordinates coordinates = await geoCode.forwardGeocoding(address: value);
    print("Latitude: ${coordinates.latitude}");
    print("Longitude: ${coordinates.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _config.uiWidthPx * 0.8,
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
                height: _config.uiHeightPx / 1.5,
                width: _config.uiWidthPx * 1,
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
                                    controlelr: currentController,
                                    prefix: PrefixIcon1(),
                                    config: _config,
                                  ),
                                  const SizedBox(height: 5.0),
                                  CustomPlaceTextWidget(
                                    hintText: "Your destination",
                                    onSubmitted: (value) {},
                                    controlelr: destinationController,
                                    prefix: const PrefixIcon2(),
                                    config: _config,
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: SizedBox(
                                      height: _config.uiHeightPx * 0.06,
                                      width: _config.uiWidthPx - 100,
                                      child: LoginButton(
                                        text: 'Search',
                                        onPress: () {
                                          autoCompleteSearch(
                                              currentController.text);
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            autoCompleteSearch(
                                                destinationController.text);
                                          });
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
                          width: _config.uiWidthPx * 1,
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


