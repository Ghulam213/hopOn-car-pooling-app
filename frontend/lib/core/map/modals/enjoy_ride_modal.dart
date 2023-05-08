import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/image_path.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../widgets/dot_widget.dart';

buildEnjoyRide(BuildContext context) {
  // Navigator.pop(context);
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return const EnjoyRide();
      });
}

class EnjoyRide extends StatefulWidget {
  const EnjoyRide({
    Key? key,
  }) : super(key: key);

  @override
  _EnjoyRideState createState() => _EnjoyRideState();
}

class _EnjoyRideState extends State<EnjoyRide> {
  final SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7),
      height: config.uiHeightPx / 1.8,
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(80)),
                color: AppColors.PRIMARY_500.withOpacity(0.5),
              )),
          const SizedBox(height: 15),
          Text(
            "Driver Is On Your Way",
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: AppColors.PRIMARY_500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Buckle Up and have a safe trip",
            style: GoogleFonts.montserrat(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: AppColors.FONT_GRAY.withOpacity(0.7),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: DotWidget(
              dashColor: AppColors.PRIMARY_500,
              dashHeight: 1.0,
              dashWidth: 2.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
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
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage(ImagesAsset.driverpic))),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Umer Zia",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.FONT_GRAY,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Toyata Corolla 2015 |",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.FONT_GRAY,
                                      ),
                                    ),
                                    Text(
                                      " AUC-206 ",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.FONT_GRAY,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 35),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rs,300",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.FONT_GRAY,
                                ),
                              ),
                              Text(
                                "Ride Charges",
                                style: GoogleFonts.montserrat(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.FONT_GRAY,
                                ),
                              ),
                            ])
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 14),
          const DotWidget(
            dashColor: AppColors.PRIMARY_500,
            dashHeight: 1.0,
            dashWidth: 2.0,
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trip Details",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.FONT_GRAY.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(ImagesAsset.side),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Location",
                          style: GoogleFonts.montserrat(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.FONT_GRAY.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Faizaabd, Islamabad",
                          style: GoogleFonts.montserrat(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF818181),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Destination",
                          style: GoogleFonts.montserrat(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.FONT_GRAY.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "NUST, Islamabad",
                          style: GoogleFonts.montserrat(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.FONT_GRAY.withOpacity(0.8),
                          ),
                        ),
                      ],
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
          const SizedBox(height: 18),
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
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Hopped On",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
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
