// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventNotification _$EventNotificationFromJson(Map<String, dynamic> json) =>
    EventNotification(
      text: json['text'] as String,
      time: const EpochDateTimeConverter().fromJson(json['time'] as int),
      repeatInterval:
          $enumDecodeNullable(_$RepeatIntervalEnumMap, json['repeatInterval']),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$EventNotificationToJson(EventNotification instance) =>
    <String, dynamic>{
      'text': instance.text,
      'time': const EpochDateTimeConverter().toJson(instance.time),
      'isActive': instance.isActive,
      'repeatInterval': _$RepeatIntervalEnumMap[instance.repeatInterval],
    };

const _$RepeatIntervalEnumMap = {
  RepeatInterval.everyMinute: 'everyMinute',
  RepeatInterval.hourly: 'hourly',
  RepeatInterval.daily: 'daily',
  RepeatInterval.weekly: 'weekly',
};
