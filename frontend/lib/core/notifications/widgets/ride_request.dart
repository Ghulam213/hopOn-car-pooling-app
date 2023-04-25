import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hop_on/config/sizeconfig/size_config.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';

import '../../../Utils/colors.dart';

class RideRequestModal extends StatelessWidget {
  final NotificationDataModel notification;
  const RideRequestModal(this.notification, {super.key});

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();
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
            child: Text('${notification.passengerName} has sent a ride request'),
          ),
          Expanded(
            child: Row(
              children: [
                Text(notification.passengerName ?? ''),
                Text('${notification.fare} PKR'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('${notification.distance} KM'),
                Text('${((notification.eta ?? 0) / 60000).round()} minutes away'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Decline'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Accept'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
