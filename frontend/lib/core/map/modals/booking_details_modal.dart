import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/core/map/modals/trip_details_modal.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';

buildBookingDetails(BuildContext context) {
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return const BookingDetials();
      });
}

class BookingDetials extends StatefulWidget {
  const BookingDetials({
    Key? key,
  }) : super(key: key);

  @override
  _BookingDetialsState createState() => _BookingDetialsState();
}

class _BookingDetialsState extends State<BookingDetials> {
  @override
  void initState() {
    // setState(() {
    //   Future.delayed(Duration(seconds: 5), () {
    //     buildEnjoyRide(context);
    //   });
    // });
    super.initState();
  }

  final SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
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
              "Booking Details",
              style: GoogleFonts.montserrat(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              color: AppColors.PRIMARY_500,
              ),
            ),
          const SizedBox(height: 10),
            Text(
            "Your Driver is coming to pick you!",
              style: GoogleFonts.montserrat(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
                color: AppColors.FONT_GRAY.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 14),
            const DotWidget(
              dashColor: AppColors.PRIMARY_500,
              dashHeight: 1.0,
              dashWidth: 2.0,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "DRIVERS INFORMATION",
                        style: GoogleFonts.montserrat(
                          fontSize: 9.0,
                        fontWeight: FontWeight.w400,
                          color: AppColors.FONT_GRAY.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                      "Umer Zia",
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: AppColors.FONT_GRAY,
                        ),
                      ),
                    const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                          "Toyata Corolla 2013 |",
                            style: GoogleFonts.montserrat(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400,
                              color: AppColors.FONT_GRAY,
                            ),
                          ),
                          
                          Text(
                          "AUC-206",
                            style: GoogleFonts.montserrat(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.FONT_GRAY,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Black Color",
                        style: GoogleFonts.montserrat(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.FONT_GRAY,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const DotWidget(
              dashColor: AppColors.PRIMARY_500,
              dashHeight: 1.0,
              dashWidth: 2.0,
            ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.start,
            // children: [
            // Text(
            //   "AVERAGE DRIVER RATING",
            //   style: GoogleFonts.montserrat(
            //     fontSize: 9.0,
            //     fontWeight: FontWeight.w300,
            //     color: AppColors.FONT_GRAY.withOpacity(0.7),
            //   ),
            // ),
            // const SizedBox(height: 5.0),
            // Row(
            //   children: [
            //     const Icon(
            //       Icons.star,
            //       size: 13,
            //       color: AppColors.PRIMARY_500,
            //     ),
            // const Icon(
            //                 Icons.star,
            //                 size: 13,
            //                 color: AppColors.PRIMARY_500,
            //               ),
            //               const Icon(
            //                 Icons.star,
            //                 size: 13,
            //                 color: AppColors.PRIMARY_500,
            //               ),
            //               const Icon(
            //                 Icons.star,
            //                 size: 13,
            //                 color: AppColors.PRIMARY_500,
            //               ),
            //               const Icon(
            //                 Icons.star,
            //                 size: 13,
            //                 color: AppColors.PRIMARY_500,
            //               ),
            //               Text(
            //                 "4.7",
            //                 style: GoogleFonts.montserrat(
            //                   fontSize: 12.0,
            //                   fontWeight: FontWeight.w700,
            //                   color: AppColors.FONT_GRAY,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ImagesAsset.time,
                  height: 12,
                  width: 12,
                color: const Color(0xFF999393),
                ),
              const SizedBox(width: 5),
                Text(
                "Driver Will Arrive In 5 munites",
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  color: const Color(0xFF999393),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10.0),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                height: 40,
              width: config.uiWidthPx * 1,
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_500,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: GoogleFonts.montserrat(
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

    );
  }
}
