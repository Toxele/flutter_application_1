import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService();

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    print(notificationResponse.notificationResponseType.name);
  }

  Future<void> showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '.',
      '..',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Хорошо?'),
        AndroidNotificationAction('id_2', 'Ладно'),
        AndroidNotificationAction('id_3', 'Удача?'),
      ],
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Антон привет!', 'Я запустил эту штуковину 🚀', notificationDetails);
  }
}
