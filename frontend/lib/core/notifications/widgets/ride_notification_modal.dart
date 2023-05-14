import 'package:flutter/material.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../map/modals/show_passenger_details_modal.dart';
import '../../map/viewmodel/map_view_model.dart';

class RideNotificationModal extends StatelessWidget {
  final NotificationDataModel notification;
  const RideNotificationModal(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();
    final MapViewModel viewModel = context.watch<MapViewModel>();
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
      height: config.uiHeightPx / 3.5,
      width: config.uiWidthPx * 1,
      decoration: const BoxDecoration(
        color: AppColors.LM_BACKGROUND_BASIC,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(
            child: Text(
              '${notification.passengerName} has sent a ride request',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(notification.passengerName ?? '',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        )),
                Text('${notification.fare} PKR',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        )),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('${notification.distance} KM',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        )),
                Text(
                    '${((notification.eta ?? 0) / 60000).round()} minutes away',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        )),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    viewModel.rejectRide(
                      rideId: notification.rideId,
                      distance: 20,
                      driverName: notification.passengerName,
                      passengerSource:
                         notification.passengerSource,
                      passengerDestination:
                          notification.passengerDestination,
                      fare: notification.fare,
                      ETA: notification.eta,
                    );
                    buildPassengerLocation(context, notification);
                  },
                  child: Text(
                    'Decline',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.acceptRide(
                      rideId: notification.rideId,
                      distance: 20,
                      driverName: notification.passengerName,
                      passengerSource:
                         notification.passengerSource,
                      passengerDestination:
                        notification.passengerDestination,
                      fare: notification.fare,
                      ETA: notification.eta,
                    );
                    buildPassengerLocation(context, notification);

                  },
                  child: Text(
                    'Accept',
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
