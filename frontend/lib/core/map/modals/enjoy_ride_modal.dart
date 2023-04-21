// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hop_on/core/map/modals/trip_details_modal.dart';
// import '../../../Utils/colors.dart';

// import 'package:flutter_svg/svg.dart';

// import '../../../Utils/image_path.dart';
// import '../../../config/sizeconfig/size_config.dart';

// buildEnjoyRide(BuildContext context) {
//   Navigator.pop(context);
//   showModalBottomSheet(
//       isDismissible: false,
//       isScrollControlled: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       clipBehavior: Clip.hardEdge,
//       context: context,
//       builder: (context) {
//         return EnjoyRide();
//       });
// }

// class EnjoyRide extends StatefulWidget {
//   const EnjoyRide({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _EnjoyRideState createState() => _EnjoyRideState();
// }

// class _EnjoyRideState extends State<EnjoyRide> {
//   final SizeConfig config = SizeConfig();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 7),
//       height: config.uiHeightPx / 1.8,
//       width: config.uiWidthPx * 1,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15),
//           topRight: Radius.circular(15),
//         ),
//       ),
//       child: Container(
//         child: Column(
//           children: [
//             Container(
//                 width: 80,
//                 height: 2.875,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(80)),
//                   color: AppColors.PRIMARY_500.withOpacity(0.5),
//                 )),
//             const SizedBox(height: 15),
//             Text(
//               "Enjoy your Ryde",
//               style: GoogleFonts.montserrat(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.FONT_GRAY,
//               ),
//             ),
//             Text(
//               "Buckle Up and have a safe trip",
//               style: GoogleFonts.montserrat(
//                 fontSize: 11.0,
//                 fontWeight: FontWeight.w300,
//                 color: AppColors.FONT_GRAY.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 14),
//             const DotWidget(
//               dashColor: AppColors.PRIMARY_500,
//               dashHeight: 1.0,
//               dashWidth: 2.0,
//             ),
//             const SizedBox(height: 14),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "DRIVERS INFORMATION",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 9.0,
//                           fontWeight: FontWeight.w300,
//                           color: AppColors.FONT_GRAY.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Row(
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   // driversDetail(context);
//                                 },
//                                 child: Container(
//                                   height: 60,
//                                   width: 60,
//                                   decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                           image: AssetImage(
//                                               ImagesAsset.driverpic))),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "David James",
//                                     style: GoogleFonts.montserrat(
//                                       fontSize: 12.0,
//                                       fontWeight: FontWeight.w700,
//                                       color: AppColors.FONT_GRAY,
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Toyata Camery 2010 |",
//                                         style: GoogleFonts.montserrat(
//                                           fontSize: 10.0,
//                                           fontWeight: FontWeight.w400,
//                                           color: AppColors.FONT_GRAY,
//                                         ),
//                                       ),
//                                       Text(
//                                         "237183AR",
//                                         style: GoogleFonts.montserrat(
//                                           fontSize: 10.0,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.FONT_GRAY,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 35),
//                           Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "N1,100",
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 12.0,
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColors.FONT_GRAY,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Final Cost",
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 10.0,
//                                     fontWeight: FontWeight.w400,
//                                     color: AppColors.FONT_GRAY,
//                                   ),
//                                 ),
//                               ])
//                         ],
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 14),
//             const DotWidget(
//               dashColor: AppColors.PRIMARY_500,
//               dashHeight: 1.0,
//               dashWidth: 2.0,
//             ),
//             const SizedBox(height: 14),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Trip Details",
//                     style: GoogleFonts.montserrat(
//                       fontSize: 9.0,
//                       fontWeight: FontWeight.w300,
//                       color: AppColors.FONT_GRAY.withOpacity(0.7),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SvgPicture.asset(ImagesAsset.side),
//                       const SizedBox(width: 10),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Current Location",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 9.0,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.FONT_GRAY.withOpacity(0.7),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             "Kwara Mall, Ilorin",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 9.0,
//                               fontWeight: FontWeight.w300,
//                               color: Color(0xFF818181),
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//                           Text(
//                             "Destination",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 9.0,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.FONT_GRAY.withOpacity(0.7),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             "Kwara Mall, Ilorin",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 9.0,
//                               fontWeight: FontWeight.w300,
//                               color: AppColors.FONT_GRAY.withOpacity(0.7),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 14),
//             DotWidget(
//               dashColor: AppColors.PRIMARY_500,
//               dashHeight: 1.0,
//               dashWidth: 2.0,
//             ),
//             SizedBox(height: 14),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         "Share ride info with:",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 9.0,
//                           fontWeight: FontWeight.w300,
//                           color: AppColors.FONT_GRAY.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Container(
//                             height: 34,
//                             width: 34,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(ImagesAsset.driverpic))),
//                           ),
//                           const SizedBox(width: 5),
//                           Text(
//                             "Isreal John",
//                             style: GoogleFonts.montserrat(
//                               fontSize: 9.0,
//                               fontWeight: FontWeight.w300,
//                               color: AppColors.FONT_GRAY.withOpacity(0.7),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         "Share ride details on:",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 9.0,
//                           fontWeight: FontWeight.w300,
//                           color: AppColors.FONT_GRAY.withOpacity(0.7),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(ImagesAsset.whatsapp))),
//                           ),
//                           const SizedBox(width: 5),
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(ImagesAsset.twitter))),
//                           ),
//                           const SizedBox(width: 5),
//                           Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage(ImagesAsset.facebook))),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50),
//               child: Container(
//                 height: 40,
//                 width: config.uiWidthPx * 1,
//                 decoration: BoxDecoration(
//                   color: AppColors.red1,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: InkWell(
//                   onTap: () {},
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Canel Ride",
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
