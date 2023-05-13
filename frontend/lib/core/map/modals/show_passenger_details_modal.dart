import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../notifications/models/notification_datamodel.dart';

buildPassengerLocation(
    BuildContext context, NotificationDataModel notification) {
  showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (context) {
        return ShowPassengerDetailsModal(
          notification: notification,
        );
      });
}

class ShowPassengerDetailsModal extends StatefulWidget {
  final NotificationDataModel notification;

  const ShowPassengerDetailsModal({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  _ShowPassengerDetailsModalState createState() =>
      _ShowPassengerDetailsModalState();
}

class _ShowPassengerDetailsModalState extends State<ShowPassengerDetailsModal> {
  final SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 7),
      height: config.uiHeightPx / 1.5,
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
          Column(children: [
            SizedBox(
              child: Text(
                '${widget.notification.passengerName} has sent a ride request',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Text(widget.notification.passengerName ?? '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                          )),
                  Text('${widget.notification.fare} PKR',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                          )),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
