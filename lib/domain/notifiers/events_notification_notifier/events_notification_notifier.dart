import 'dart:async';

import 'package:flutter_application_1/domain/services/notification_service/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show RepeatInterval;

import '../abstract/records_notifier.dart';
import 'event_notification.dart';

base class EventsNotificationNotifier
    extends RecordsNotifier<EventNotification> {
  EventsNotificationNotifier({
    required NotificationService notificationService,
  }) : _notificationService = notificationService;

  final NotificationService _notificationService;

  @override
  String get fileName => 'events_notification_data.json';

  // todo: recordList.reversed.toList(); внутри ui сделать это

  @override
  EventNotification serializeElement(Map<String, dynamic> dataElement) =>
      EventNotification.fromJson(dataElement);

  @override
  Map<String, dynamic> deserializeElement(EventNotification element) =>
      element.toJson();

  Future<void> saveRecord({
    required String text,
    required DateTime time,
    bool? isActive,
    RepeatInterval? repeatInterval,
  }) async {
    var event = _createEvent(
      time: time,
      text: text,
      repeatInterval: repeatInterval,
    );

    await _notificationService.addEvent(
      id: event.uuid,
      message: event.text,
      time: event.time, 
    );

    if (isActive != null) event = event.copyWith(isActive: isActive);

    await addRecord(event);
  }

  EventNotification _createEvent({
    required String text,
    required DateTime time,
    bool isActive = true,
    RepeatInterval? repeatInterval,
  }) =>
      EventNotification(
        text: text,
        time: time,
        isActive: isActive,
        repeatInterval: repeatInterval,
      );

  Future<void> updateNotificationRecord({
    required String text,
    required DateTime time,
    required bool? isActive,
    required EventNotification oldRecord,
    RepeatInterval? repeatInterval,
  }) async {
    
   // time = DateTime.now().add(const Duration(minutes: 1));
    final EventNotification newEvent = _createEvent(
      text: text,
      time: time,
      isActive: isActive ?? false,
      repeatInterval: repeatInterval,
    ); 
    await _notificationService.updateEvent(
      id: newEvent.uuid,
      message: newEvent.text,
      time: newEvent.time,
      repeatInterval: repeatInterval,
    );

    await updateRecord(oldElement: oldRecord, newElement: newEvent);
  }
}
