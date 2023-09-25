// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventNotification _$EventNotificationFromJson(Map<String, dynamic> json) =>
    EventNotification(
      uuid: json['uuid'] as int,
      text: json['text'] as String,
      time: const EpochDateTimeConverter().fromJson(json['time'] as int),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$EventNotificationToJson(EventNotification instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'text': instance.text,
      'time': const EpochDateTimeConverter().toJson(instance.time),
      'isActive': instance.isActive,
    };
