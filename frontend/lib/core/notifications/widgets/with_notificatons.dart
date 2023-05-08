import 'package:flutter/material.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';
import 'package:hop_on/core/notifications/services/notification_service.dart';
import 'package:hop_on/core/notifications/widgets/ride_notification_modal.dart';

Map<String, Function(BuildContext, NotificationDataModel)> notificationsConfig = {
  'RIDE_REQUEST': (BuildContext context, NotificationDataModel notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => RideNotificationModal(notification),
    );
  },
};

class WithNotifications extends StatefulWidget {
  final Widget child;

  const WithNotifications({required Key key, required this.child}) : super(key: key);

  @override
  WithNotificationsState createState() => WithNotificationsState();
}

class WithNotificationsState extends State<WithNotifications> {
  List<NotificationDataModel> notifications = [];

  @override
  void initState() {
    super.initState();
    NotificationService notificationService = NotificationService(
      onNotificationReceived: (NotificationDataModel notification) {
        notificationsConfig[notification.type]!(context, notification);

        setState(() {
          notifications.add(notification);
        });
      },
    );
    notificationService.registerNotification();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
