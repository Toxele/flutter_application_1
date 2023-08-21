// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotificationRecord _$UserNotificationRecordFromJson(
        Map<String, dynamic> json) =>
    UserNotificationRecord(
      json['text'] as String?,
      const EpochDateTimeConverter().fromJson(json['timeToNotificate'] as int),
    );

Map<String, dynamic> _$UserNotificationRecordToJson(
        UserNotificationRecord instance) =>
    <String, dynamic>{
      'text': instance.text,
      'timeToNotificate':
          const EpochDateTimeConverter().toJson(instance.timeToNotificate),
    };
