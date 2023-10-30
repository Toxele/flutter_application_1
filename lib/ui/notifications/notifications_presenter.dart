import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/abstract/records_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/events_notification_notifier.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show RepeatInterval;

sealed class NotificationsScreenState {
  const NotificationsScreenState();
}

class NotificationsScreenData extends NotificationsScreenState {
  const NotificationsScreenData(this.data);

  final List<EventNotification> data;
}

class NotificationsScreenLoading extends NotificationsScreenState {
  const NotificationsScreenLoading();
}

class NotificationsScreenError extends NotificationsScreenState {
  const NotificationsScreenError(this.message);

  final String message;
}

class NotificationsScreenEmpty extends NotificationsScreenState {
  const NotificationsScreenEmpty();
}

class NotificationsScreenPresenter
    extends ValueNotifier<NotificationsScreenState> {
  NotificationsScreenPresenter({
    required EventsNotificationNotifier eventsNotificationNotifier,
  })  : _eventsNotificationNotifier = eventsNotificationNotifier,
        super(const NotificationsScreenLoading()) {
    load();
  }

  final EventsNotificationNotifier _eventsNotificationNotifier;

  Future<void> addRecord({
    required String text,
    required DateTime time,
    bool? isActive,
    RepeatInterval? repeatInterval,
  }) async {
    value = const NotificationsScreenLoading();
    await _eventsNotificationNotifier.saveRecord(
      text: text,
      time: time,
      isActive: isActive,
      repeatInterval: repeatInterval,
    );
  }

  Future<void> updateRecord({
    required String text,
    required DateTime time,
    bool? isActive,
    RepeatInterval? repeatInterval,
    required EventNotification oldRecord,
  }) async {
    value = const NotificationsScreenLoading();

    await _eventsNotificationNotifier.updateNotificationRecord(
      text: text,
      time: time,
      isActive: isActive,
      repeatInterval: repeatInterval,
      oldRecord: oldRecord,
    );
  }

  /// Вернёт флаг, указывающий на то, что деактивированные уведомляшки были.
  bool _deactivateWhereShown(
    List<EventNotification> data,
  ) {
    final timeNow = DateTime.now();
    bool hasDeactivated = false;
    for (final notify in data) {
      if (notify.time.isBefore(timeNow) && notify.isActive) {
        
        hasDeactivated = true;
        unawaited(
          _eventsNotificationNotifier.updateNotificationRecord(
            text: notify.text,
            time: notify.time,
            isActive: false,
            repeatInterval: notify.repeatInterval,
            oldRecord: notify, 
          ),
        );
        
      }
    }

    return hasDeactivated;
  }

  Future<void> load() async {
    value = switch (_eventsNotificationNotifier.value) {
      RecordsNotifierData(data: final records) => _deactivateWhereShown(records)
          ? const NotificationsScreenLoading() 
          : NotificationsScreenData(records),
      RecordsNotifierLoading() => const NotificationsScreenLoading(),
      RecordsNotifierEmpty() => const NotificationsScreenEmpty(),
    };
  } 
}
