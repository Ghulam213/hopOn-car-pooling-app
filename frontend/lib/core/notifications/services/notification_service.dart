// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hop_on/core/notifications/models/notification_datamodel.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late Function(NotificationDataModel notification) onNotificationReceived;
  bool isNotificationRegistered = false;

  factory NotificationService({required onNotificationReceived}) {
    _instance.onNotificationReceived = onNotificationReceived;
    return _instance;
  }

  NotificationService._internal();

  void registerNotification() async {
    if (isNotificationRegistered) {
      return;
    }
    try {
      isNotificationRegistered = true;
      await requestPermissions();
      await getToken();
      await initNotificationPlugin();
      attachForegroundNotificationHandler();
      attachBackgroundNotificationHandler();
    } catch (e) {
      isNotificationRegistered = false;
      debugPrint("Error: $e");
    }
  }

  Future<void> initNotificationPlugin() async {
    var androidInitialize = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
            print('notification payload: $payload');
          } else {}
        } catch (e) {
          print(e);
        }
        return;
      },
    );
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    // TODO: Make a request to the server to save the token
    print('Device Token: $token');
  }

  Future<void> requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      throw Exception('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in foreground
  void attachForegroundNotificationHandler() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        print(".........onMessage...........");
        print(
          "onMessage: ${message.data['type']}/${message.notification?.title}/${message.notification?.body}",
        );

        onNotificationReceived(NotificationDataModel.fromJson(message.data));

        BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true,
        );
        AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          playSound: true,
          // sound: RawResourceAndroidNotificationSound('notification'),
        );
        IOSNotificationDetails iosPlatformChannelSpecifics = const IOSNotificationDetails();
        NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title,
          message.notification?.body,
          platformChannelSpecifics,
          payload: message.data['title'],
        );
      },
    );
  }

  // For handling notification when the app is in background
  void attachBackgroundNotificationHandler() {
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // TODO: Handle initial message
      print("Handle initial message");
    }
  }
}
