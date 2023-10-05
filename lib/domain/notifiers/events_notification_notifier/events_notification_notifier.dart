// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';

import 'package:flutter_application_1/domain/services/notification_service/notification_service.dart';
import 'package:uuid/v7.dart';

import '../abstract/records_notifier.dart';
import 'event_notification.dart';

// todo доработать логику всего класса
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

  String get _uuid => const UuidV7().generate();

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

    _notificationService.addEvent(
      id: event.uuid,
      message: event.text,
      time: event.time,
    );

    if (isActive != null) event = event.copyWith(isActive: isActive);

    addRecord(event);
  }

  Future<void> updateRecord({
    required String text,
    required DateTime time,
    required bool? isActive,
    required EventNotification oldRecord,
  }) async {
    // todo
    // реализовать метод, выделить создание объекта в отдельный приватный метод
    updateRecord();
  }
}
