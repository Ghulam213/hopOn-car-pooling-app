import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../map/viewmodel/map_view_model.dart';

class RideNotificationModal extends StatelessWidget {
  final NotificationDataModel notification;
  const RideNotificationModal(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();
    final MapViewModel viewModel = context.watch<MapViewModel>();
    return Container(
      padding: const EdgeInsets.only(top: 7),
      height: config.uiHeightPx / 2.8,
      width: config.uiWidthPx * 1,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              width: 80,
              height: 2.875,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(80)),
                color: AppColors.PRIMARY_500.withOpacity(0.9),
              )),
          const SizedBox(height: 10),
          SizedBox(
            child: Text(
              '${notification.passengerName} has sent a ride request',
              style: GoogleFonts.montserrat(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: AppColors.PRIMARY_500,
              ),
            ),
        
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  notification.passengerName ?? '',
                  style: GoogleFonts.montserrat(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.FONT_GRAY.withOpacity(0.8),
                  ),
                ),
                Text(
                  '${notification.fare} PKR',           
                  style: GoogleFonts.montserrat(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.FONT_GRAY.withOpacity(0.8),
                  ),
                ),           
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${notification.distance} KM',
                  style: GoogleFonts.montserrat(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.FONT_GRAY.withOpacity(0.8),
                  ),
                ),
                Text(
                  '${((notification.eta ?? 0) / 60000).round()} minutes away',
                  style: GoogleFonts.montserrat(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.FONT_GRAY.withOpacity(0.8),
                  ),
                ),
           
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               
                ElevatedButton(
                  onPressed: () {
                    viewModel.acceptRide(
                      rideId: notification.rideId,
                      distance: notification.distance,
                      driverName: notification.passengerName,
                      passengerSource: notification.passengerSource,
                      passengerDestination: notification.passengerDestination,
                      fare: notification.fare,
                      ETA: notification.eta,
                    );
                    navigator?.pop(context);
                  },
                  child: Text(
                    'Accept',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.rejectRide(
                      rideId: notification.rideId,
                      distance: notification.distance,
                      driverName: notification.passengerName,
                      passengerSource: notification.passengerSource,
                      passengerDestination: notification.passengerDestination,
                      fare: notification.fare,
                      ETA: notification.eta,
                    );
                    navigator?.pop(context);
                  },
                  child: Text(
                    'Decline',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
