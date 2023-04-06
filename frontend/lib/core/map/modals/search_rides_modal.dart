import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/auth/widgets/login_button.dart';
import 'package:hop_on/core/map/modals/trip_details_modal.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _config.uiWidthPx * 0.8,
      child: const LoginButton(
        text: "Start a Ride ?",
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
                child: pickLocation(context, _config, currentController,
                    destinationController, widget.onRideRequest),
              );
            });
      }),
    );
  }
}

Widget pickLocation(
    BuildContext context,
    SizeConfig _config,
    TextEditingController controller1,
    TextEditingController controller2,
    Function() onRideRequest) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          Container(
              width: 80,
              height: 2.875,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(80)),
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
                          AppColors.PRIMARY_500, BlendMode.srcIn)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomPlaceTextWidget(
                      hintText: "Current location",
                      // onSubmitted: (_) {
                      //   buildTripDetails(
                      //       context, controller1.text, controller2.text);
                      // },
                      controlelr: controller1,
                      prefix: PrefixIcon1(),
                      config: _config,
                    ),
                    const SizedBox(height: 5.0),
                    CustomPlaceTextWidget(
                      hintText: "Your destination",
                      // onSubmitted: (_) {
                      //   buildTripDetails(
                      //       context, controller1.text, controller2.text);
                      // },
                      controlelr: controller2,
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
                          text: 'Search ',
                          onPress: () {
                
                            buildTripDetails(
                                context, controller1.text,
                                controller2.text, onRideRequest);
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
  );
}

class CustomPlaceTextWidget extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final Widget? prefix;
  final String hintText;
  final SizeConfig config;
  final TextEditingController controlelr;

  CustomPlaceTextWidget(
      {this.onSubmitted,
      this.suffix,
      this.prefix,
      required this.hintText,
      required this.config,
      required this.controlelr,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      height: 55,
      width: config.uiWidthPx - 60,
      child: TextField(
        scrollPadding: const EdgeInsets.symmetric(vertical: 15),
        onSubmitted: onSubmitted,
        controller: controlelr,
        cursorColor: AppColors.FONT_GRAY,
        keyboardType: TextInputType.streetAddress,
        autofillHints: const [AutofillHints.addressCity],
        style: GoogleFonts.montserrat(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: AppColors.PRIMARY_500.withOpacity(0.8),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: prefix ?? prefix,
          filled: true,
          fillColor: AppColors.PRIMARY_500.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.PRIMARY_500,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppColors.PRIMARY_500),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.PRIMARY_500.withOpacity(0.9),
              ),
        ),
      ),
    );
  }
}

class PrefixIcon2 extends StatelessWidget {
  const PrefixIcon2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SvgPicture.asset(
        ImagesAsset.locate,
        colorFilter:
            const ColorFilter.mode(AppColors.PRIMARY_500, BlendMode.srcIn),
        height: 10,
        width: 10,
      ),
    );
  }
}

class SuffixNow1 extends StatelessWidget {
  const SuffixNow1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {},
      child: Container(
          height: 25,
          width: 60,
          decoration: const BoxDecoration(
              color: AppColors.PRIMARY_500,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 13.0,
                color: Colors.white,
              ),
              Text("Now",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
            ],
          )).ripple(() {}),
    );
  }
}

class PrefixIcon1 extends StatelessWidget {
  PrefixIcon1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(ImagesAsset.car,
          colorFilter:
              const ColorFilter.mode(AppColors.PRIMARY_500, BlendMode.srcIn),
          height: 15,
          width: 15),
    );
  }
}
