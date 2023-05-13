import 'package:flutter/material.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';

class NotificationsModel extends ChangeNotifier {
  List<NotificationDataModel> _notifications = [];

  List<NotificationDataModel> get notifications => _notifications;

  set notifications(List<NotificationDataModel> notifications) {
    _notifications = notifications;
    notifyListeners();
  }

  void addNotification(NotificationDataModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(NotificationDataModel notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void updateNotification(NotificationDataModel notification) {
    int index = _notifications.indexWhere((element) => element.rideId == notification.rideId);
    _notifications[index] = notification;
    notifyListeners();
  }

  NotificationDataModel? getLatestNotification(String type) {
    List<NotificationDataModel> notifications = _notifications.where((element) => element.type == type).toList();
    if (notifications.isNotEmpty) {
      return notifications[notifications.length - 1];
    }
    return null;
  }
}
