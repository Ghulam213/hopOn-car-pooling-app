import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/core/map/modals/trip_details_modal.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import 'booking_details_modal.dart';

buildConfirmTrip(BuildContext context) {
  Navigator.pop(context);
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return const BookingComfirm();
      });
}

class BookingComfirm extends StatefulWidget {
  const BookingComfirm({
    Key? key,
  }) : super(key: key);

  @override
  _BookingComfirmState createState() => _BookingComfirmState();
}

class _BookingComfirmState extends State<BookingComfirm> {
  @override
  void initState() {
    setState(() {
      Future.delayed(const Duration(seconds: 8), () {
        Navigator.pop(context);
        buildBookingDetails(context);
      });
    });
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
              "Ride confimed",
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
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         children: [
            //           InkWell(
            //             onTap: () {
            //               // driversDetail(context);
            //             },
            //             child: Container(
            //               height: 50,
            //               width: 50,
            //               decoration: BoxDecoration(
            //                   image: DecorationImage(
            //                       image: AssetImage(ImagesAsset.driverpic))),
            //             ),
            //           ),
            //           SizedBox(height: 8.0),
            //           Text(
            //             "Your Driver",
            //             style: GoogleFonts.montserrat(
            //               fontSize: 10.0,
            //               fontWeight: FontWeight.w400,
            //               color: AppColors.FONT_GRAY,
            //             ),
            //           )
            //         ],
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.pop(context);
            //         },
            //         child: Column(
            //           children: [
            //             Container(
            //               height: 50,
            //               width: 50,
            //               decoration: const BoxDecoration(
            //                   color: AppColors.FONT_GRAY,
            //                   borderRadius: BorderRadius.all(
            //                     Radius.circular(11),
            //                   )),
            //               child: SvgPicture.asset(ImagesAsset.cancelride),
            //             ),
            //             const SizedBox(height: 8.0),
            //             Text(
            //               "Cancel Ride",
            //               style: GoogleFonts.montserrat(
            //                 fontSize: 10.0,
            //                 fontWeight: FontWeight.w400,
            //                 color: AppColors.FONT_GRAY,
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
