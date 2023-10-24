import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/abstract/records_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/events_notification_notifier.dart';

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
  }) async {
    value = const NotificationsScreenLoading();
    await _eventsNotificationNotifier.saveRecord(
      text: text,
      time: time,
      isActive: isActive,
    );
  }

  Future<void> updateRecord({
    required String text,
    required DateTime time,
    bool? isActive,
    required EventNotification oldRecord,
  }) async {
    value = const NotificationsScreenLoading();

    await _eventsNotificationNotifier.updateNotificationRecord(
      text: text,
      time: time,
      isActive: isActive,
      oldRecord: oldRecord,
    );
  }

  Future<void> _turnOffShown(List<EventNotification> data) async {
    // todo: снять флажок у всех уведомлений, которые уже были показаны
    // реализовать на основе текущего времени
  }

  Future<void> load() async {
    value = switch (_eventsNotificationNotifier.value) {
      RecordsNotifierData(data: final records) => await () async {
          await _turnOffShown(records);
          return NotificationsScreenData(records);
        }(),
      RecordsNotifierLoading() => const NotificationsScreenLoading(),
      RecordsNotifierEmpty() => const NotificationsScreenEmpty(),
    };
  }
}
