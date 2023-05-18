import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/dot_widget.dart';
import 'booking_details_modal.dart';

buildConfirmTrip(BuildContext context, int index) {
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return BookingComfirm(index: index);
      });
}

class BookingComfirm extends StatefulWidget {
  int? index;
  BookingComfirm({
    Key? key,
    required index,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookingComfirmState createState() => _BookingComfirmState();
}

class _BookingComfirmState extends State<BookingComfirm> {
  @override
  void initState() {
    if (context.mounted) {
      Future.delayed(const Duration(seconds: 15), () {
        buildBookingDetails(context, widget.index);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();

    return Container(
      padding: const EdgeInsets.only(top: 7),
      height: config.uiHeightPx / 2.5,
      width: config.uiWidthPx * 1,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
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
            "Ride confirmed",
            style: GoogleFonts.montserrat(
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
              color: AppColors.FONT_GRAY,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Finding you a driver",
            style: GoogleFonts.montserrat(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: AppColors.FONT_GRAY,
            ),
          ),
          const SizedBox(height: 20),
          const DotWidget(
            dashColor: AppColors.PRIMARY_500,
            dashHeight: 1.0,
            dashWidth: 2.0,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 70,
            width: 70,
            child: Image(
              image: AssetImage(ImagesAsset.ripple),
              color: AppColors.PRIMARY_500,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
