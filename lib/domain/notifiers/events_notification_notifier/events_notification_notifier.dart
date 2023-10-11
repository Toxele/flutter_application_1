// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';

import 'package:flutter_application_1/domain/services/notification_service/notification_service.dart';

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
  }) async {
    var event = EventNotification(
      time: time,
      text: text,
      uuid: DateTime.now().millisecondsSinceEpoch,
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
    required int uuid,
    required bool isActive,
  }) =>
      EventNotification(
        uuid: uuid,
        text: text,
        time: time,
        isActive: isActive,
      );

  // todo
  // String get _uuid => const UuidV7().generate();

  Future<void> updateNotificationRecord({
    required String text,
    required DateTime time,
    required bool? isActive,
    required EventNotification oldRecord,
  }) async {
    final EventNotification newEvent = _createEvent(
      uuid: oldRecord.uuid,
      text: text,
      time: time,
      isActive: isActive ?? false,
    );

    await _notificationService.updateEvent(
      id: newEvent.uuid,
      message: newEvent.text,
      time: newEvent.time,
    );

    await updateRecord(oldElement: oldRecord, newElement: newEvent);
  }
}
