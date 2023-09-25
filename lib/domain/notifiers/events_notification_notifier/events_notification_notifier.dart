// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:convert';

import 'package:flutter_application_1/domain/services/notification_service/notification_service.dart';
import 'package:uuid/v7.dart';

import '../abstract/records_notifier.dart';
import 'event_notification.dart';

// todo доработать логику всего класса
base class EventsNotificationNotifier
    extends RecordsNotifier<List<EventNotification>> {
  EventsNotificationNotifier({
    required NotificationService notificationService,
  }) : _notificationService = notificationService;

  final NotificationService _notificationService;

  @override
  String get fileName => '\\events_notification_data.json';

  @override
  Future<List<EventNotification>> serializeData(String data) async {
    final recordList = <EventNotification>[];
    for (final record in jsonDecode(data) as List) {
      recordList
          .add(EventNotification.fromJson(record as Map<String, dynamic>));
    } 
    return recordList.reversed.toList();
  }

  String get _uuid => const UuidV7().generate();

  Future<void> saveRecord({
    required String text,
    required DateTime time,
    bool? isActive,
  }) async {
    var records = <EventNotification>[];
    if (value case RecordsNotifierData(data: final data)) {
      value = const RecordsNotifierLoading();
      records = [...data];
    }
    value = const RecordsNotifierLoading();

    final user = EventNotification(
      time: time,
      text: text,
      uuid: DateTime.now().millisecondsSinceEpoch,
    );

    _notificationService.addEvent(
      id: user.uuid,
      message: user.text,
      time: user.time,
    );

    if (isActive != null) user.copyWith(isActive: isActive);

    records.add(user);
    final recordsRaw = records.map((e) => e.toJson()).toList();
    addRecord(recordsRaw);
    load();
  }
}
