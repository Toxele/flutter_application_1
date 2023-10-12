import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// todo начать использовать
class NotificationService {
  NotificationService();

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    notificationAppLaunchDetails =
        kIsWeb || Platform.isLinux || Platform.isWindows
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

  Future<void> updateEvent({
    required String message,
    required int id,
    required DateTime time,
  }) async {
    if (Platform.isWindows) return;

    await flutterLocalNotificationsPlugin.cancel(id);
    await addEvent(
      message: message,
      id: id,
      time: time,
    );
  }

  Future<void> showNowTest() async {
    const androidNotificationDetails = AndroidNotificationDetails(
      '.',
      '..',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('yes', 'Ок'),
        AndroidNotificationAction('yes', 'Отложить'),
      ],
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Антон привет!',
      'Я запустил эту штуковину 🚀',
      notificationDetails,
    );
  }

  Future<void> addEvent({
    required String message,
    required int id,
    required DateTime time,
  }) async {
    tz.initializeTimeZones();

    const androidNotificationDetails = AndroidNotificationDetails(
      '.',
      '..',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('yes', 'Ок'),
        AndroidNotificationAction('yes', 'Отложить'),
      ],
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // todo: удалить это, а для windows систем вообще не внедрять уведомляшки
    if (Platform.isWindows) return;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Вы просили уведомить...',
        message,
        tz.TZDateTime.now(tz.local)
            .add(Duration(milliseconds: time.millisecondsSinceEpoch)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } on PlatformException catch (e, s) {
      debugPrint(e.message);
      debugPrint(s.toString());

      throw '';
    }
  }
}
