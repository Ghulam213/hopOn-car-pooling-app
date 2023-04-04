import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/map/modals/trip_details_modal.dart';
import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';

class SearchRidesModal extends StatefulWidget {
  final Function() onCloseTap;
  final Function(String) onErrorOccurred;
  final Function() onSuccess;

  const SearchRidesModal(
      {Key? key,
      required this.onCloseTap,
      required this.onErrorOccurred,
      required this.onSuccess})
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 55,
        width: _config.uiWidthPx * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: AppColors.PRIMARY_500.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SvgPicture.asset(ImagesAsset.car, height: 25, width: 25),
              const SizedBox(height: 10),
              Text(
                "Where to ?",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.PRIMARY_500,
                    ),
              ),
            ]),
          ],
        ),
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
                height: _config.uiHeightPx - 110,
                width: _config.uiWidthPx * 1,
                decoration: const BoxDecoration(
                  color: AppColors.LM_BACKGROUND_BASIC,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: pickLocation(context, _config),
              );
            });
      }),
    );
  }
}

Widget pickLocation(BuildContext context, SizeConfig _config) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          Container(
              width: 80,
              height: 2.875,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(80)),
                color: AppColors.PRIMARY_500.withOpacity(0.5),
              )),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                SvgPicture.asset(ImagesAsset.side),
                Column(
                  children: [
                    CustomPlaceTextWidget(
                      hintText: "Current location",
                      onSubmitted: (_) {
                        buildTripDetails(context);
                      },
                      prefix: PrefixIcon1(),
                      config: _config,
                    ),
                    const SizedBox(height: 5.0),
                    CustomPlaceTextWidget(
                      hintText: "Your current location",
                      onSubmitted: (_) {
                        buildTripDetails(context);
                      },
                      // suffix: const SuffixNow2(),
                      prefix: const PrefixIcon2(),
                      config: _config,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      Column(
        children: [
          SvgPicture.asset(ImagesAsset.stopwatch),
          const SizedBox(height: 10),
          Text(
            "Consider the driver and don’t keep the driver waiting.",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.PRIMARY_500,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "You will be charged an additional N150 for every minute you \nkeep the driver waiting",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 8.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999393),
                ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 70,
            width: _config.uiWidthPx * 1,
            decoration: const BoxDecoration(
              color: AppColors.FONT_GRAY,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImagesAsset.globe),
                  const SizedBox(width: 5),
                  Text(
                    "Search on Map",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                  )
                ]),
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

  final TextEditingController placetexteditingcontroller =
      TextEditingController();
  CustomPlaceTextWidget(
      {this.onSubmitted,
      this.suffix,
      this.prefix,
      required this.hintText,
      required this.config,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      height: 55,
      width: config.uiWidthPx - 60,
      child: TextField(
        scrollPadding: EdgeInsets.symmetric(vertical: 15),
        onSubmitted: onSubmitted,
        controller: placetexteditingcontroller,
        cursorColor: AppColors.FONT_GRAY,
        keyboardType: TextInputType.streetAddress,
        autofillHints: const [AutofillHints.addressCity],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: prefix ?? prefix,
          suffix: suffix ?? suffix,
          filled: true,
          fillColor: AppColors.PRIMARY_500.withOpacity(0.9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Colors.transparent,
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
                color: AppColors.PRIMARY_300.withOpacity(0.9),
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

class SuffixNow2 extends StatelessWidget {
  const SuffixNow2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
                color: AppColors.PRIMARY_500,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: const Icon(
              Icons.add,
              size: 12.0,
              color: Colors.white,
            )));
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
      child: SvgPicture.asset(ImagesAsset.car, height: 15, width: 15),
    );
  }
}
