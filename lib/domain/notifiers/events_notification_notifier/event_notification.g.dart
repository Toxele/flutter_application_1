// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventNotification _$UserNotificationRecordFromJson(Map<String, dynamic> json) =>
    EventNotification(
      text: json['text'] as String?,
      timeToNotificate: const EpochDateTimeConverter()
          .fromJson(json['timeToNotificate'] as int),
      notificateThis: json['notificateThis'] as bool?,
    );

Map<String, dynamic> _$UserNotificationRecordToJson(
        EventNotification instance) =>
    <String, dynamic>{
      'text': instance.text,
      'timeToNotificate':
          const EpochDateTimeConverter().toJson(instance.timeToNotificate),
      'notificateThis': instance.notificateThis,
    };