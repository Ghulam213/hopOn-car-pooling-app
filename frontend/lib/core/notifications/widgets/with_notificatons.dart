import 'package:flutter/material.dart';
import 'package:hop_on/Utils/helpers.dart';
import 'package:hop_on/core/map/viewmodel/map_view_model.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';
import 'package:hop_on/core/notifications/models/notifications_model.dart';
import 'package:hop_on/core/notifications/services/notification_service.dart';
import 'package:hop_on/core/notifications/widgets/ride_notification_modal.dart';
import 'package:provider/provider.dart';

Map<String, Function(BuildContext, NotificationDataModel)> notificationsConfig =
    {
  'RIDE_REQUEST': (BuildContext context, NotificationDataModel notification) {
    logger('in Ride Request');
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) => RideNotificationModal(notification),
    );
  },
  'RIDE_ACCEPTED': (BuildContext context, NotificationDataModel notification) {
    final MapViewModel viewModel =
        Provider.of<MapViewModel>(context, listen: false);
    // set the cron job to update passenger location
    viewModel.hasDriverAcceptedPassengerRideRequest = true;
    viewModel.rideId = notification.rideId!;
    viewModel.updatePassengerLoc();
    viewModel.getRideLocation(notification.rideId!);
    viewModel.cronUpdatePassengerLoc();
    viewModel.cronGetRideLoc();
  },
};

class WithNotifications extends StatefulWidget {
  final Widget child;

  const WithNotifications({required Key key, required this.child})
      : super(key: key);

  @override
  WithNotificationsState createState() => WithNotificationsState();
}

class WithNotificationsState extends State<WithNotifications> {
  late NotificationsModel notificationsModel;
  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      notificationsModel =
          Provider.of<NotificationsModel>(context, listen: false);

      NotificationService notificationService = NotificationService(
        onNotificationReceived: (NotificationDataModel notification) {
          notificationsConfig[notification.type]!(context, notification);

          notificationsModel.addNotification(notification);
        },
      );
      notificationService.registerNotification();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
