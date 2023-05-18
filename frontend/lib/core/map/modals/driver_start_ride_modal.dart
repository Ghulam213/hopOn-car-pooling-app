import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/network/resources.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/textfield_icons.dart';
import '../viewmodel/map_view_model.dart';

class StartRideModal extends StatefulWidget {
  final Function(String, String) onRideStarted;

  const StartRideModal({Key? key, required this.onRideStarted})
      : super(key: key);

  @override
  StartRideModalState createState() => StartRideModalState();
}

class StartRideModalState extends State<StartRideModal> {
  final SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController currentController =
      TextEditingController(text: '');
  final TextEditingController destinationController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final MapViewModel mapViewModel = context.watch<MapViewModel>();

    return SizedBox(
      width: config.uiWidthPx * 0.7,
      child: const LoginButton(
        text: "Start a Ride ?",
        isLoading: false,
      ).ripple(
        () {
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
                  child: Consumer<MapViewModel>(builder:
                      (BuildContext context, MapViewModel viewModel, _) {
                    if (viewModel.createRideResource.ops ==
                        NetworkStatus.LOADING) {
                      return SizedBox(
                        height: config.sh(25).toDouble(),
                        width: config.sw(25).toDouble(),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    // else if (viewModel.createRideResource.ops ==
                    //     NetworkStatus.SUCCESSFUL) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                                width: 80,
                                height: 2.875,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(80)),
                                  color: AppColors.PRIMARY_500.withOpacity(0.5),
                                )),
                            const SizedBox(height: 40),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomPlaceTextWidget(
                                        hintText: "Current location",
                                        onSubmitted: (value) {                                      
                                        },
                                        controller: currentController,
                                        prefix: const PrefixIcon1(),
                                        onChanged: (value) {                                        
                                        },
                                        config: config,
                                      ),
                                      const SizedBox(height: 5.0),
                                      CustomPlaceTextWidget(
                                        hintText: "going where?",
                                        onSubmitted: (value) {                                        
                                        },
                                        controller: destinationController,
                                        prefix: const PrefixIcon2(),
                                        onChanged: (value) {
                                       
                                        },
                                        config: config,
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: SizedBox(
                                          height: config.uiHeightPx * 0.06,
                                          width: config.uiWidthPx - 100,
                                          child: LoginButton(
                                            text: 'Start',
                                            onPress: () async {
                                              logger(currentController.text);
                                              logger(
                                                  destinationController.text);
                                              var src = await Future.wait([
                                                autoCompleteSearch(
                                                  currentController.text,
                                                ),
                                                autoCompleteSearch(
                                                  destinationController.text,
                                                ),
                                                getCurrentLocation()
                                              ]);

                                              logger(src[0]);
                                              logger(src[1]);
                                              if (src.isNotEmpty) {
                                                await mapViewModel.createRide(
                                                  source: src[0] != null
                                                      ? src[0].toString()
                                                      : src[2].toString(),
                                                  destination:
                                                      src[1].toString(),
                                                  currentLocation:
                                                      src[2].toString(),
                                                  totalDistance: 30,
                                                  city: 'Islamabad',
                                                );
                                              }

                                              widget.onRideStarted(
                                                src[0].toString(),
                                                src[1].toString(),
                                              );
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
                      ],
                    );
                  }));
            },
          );
        },
      ),
    );
  }
}
