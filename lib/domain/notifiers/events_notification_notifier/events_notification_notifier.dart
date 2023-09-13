// ignore_for_file: prefer_final_locals, file_names, cast_nullable_to_non_nullable, unused_field

import 'dart:async';
import 'dart:convert';

import '../abstract/records_notifier.dart';
import 'event_notification.dart';

// todo доработать логику всего класса
base class EventsNotificationNotifier
    extends RecordsNotifier<List<EventNotification>> {
  EventsNotificationNotifier();

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

  Future<void> saveRecord({
    String text = "",
    required DateTime timeToNotificate,
  }) async {
    if (value case RecordsNotifierData(data: final data)) {
      // TODO : пофиксить if - value принимает состояние RecordsNotifierEmpty, в hypertension_notifier.dart скорее всего та же проблема
      value = const RecordsNotifierLoading();

      final user =
          EventNotification(timeToNotificate: timeToNotificate, text: text);

      data.add(user);
      final recordsRaw = data.map((e) => e.toJson()).toList();
      addRecord(recordsRaw);
      load();
    }
  }
}
