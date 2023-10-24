import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_application_1/utils/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService with CustomLog {
  NotificationService();

  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  Future<void> init() async {
    tz.initializeTimeZones();

    // todo: нужно ли оно по итогу?
    // await AndroidFlutterLocalNotificationsPlugin.requestExactAlarmsPermission();

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

  Future<void> showAllPendingNotifications() async {
    final notifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    if (notifications.isEmpty) return l.debug('Нет отложенных уведомлений');

    l.info(() {
      for (final notif in notifications) {
        String result = 'id: ${notif.id}\n';
        result += 'title: ${notif.title}\n';
        result += 'body: ${notif.body}\n';
        result += 'payload: ${notif.payload}\n';
        return 'Уведомление ожидает поставки: $result';
      }
    });
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
    bool isPeriodically = false,
    RepeatInterval? repeatInterval,
  }) async {
    assert(!isPeriodically || (isPeriodically && repeatInterval != null));

    if (Platform.isWindows) return;

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

    final timeUtc = tz.TZDateTime.from(
      time.copyWith(
        second: 0,
        millisecond: 0,
        microsecond: 0,
      ),
      tz.local,
    );

    // todo: не могу вывести локальное время здесь
    l.info('Выбранное время UTC:$timeUtc, Local:${timeUtc.toLocal()}');

    try {
      if (isPeriodically) {
        await flutterLocalNotificationsPlugin.periodicallyShow(
          id,
          'Периодичное уведомление',
          message,
          repeatInterval!,
          notificationDetails,
        );
      } else {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          'Вы просили уведомить...',
          message,
          timeUtc,
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    } on PlatformException catch (e, s) {
      l.error('Ошибка при отправке запроса на показ уведомления', e, s);
    }
  }
}
