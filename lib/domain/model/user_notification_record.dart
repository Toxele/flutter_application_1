import 'package:flutter_application_1/service classes/date_time_converter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_notification_record.g.dart';

@JsonSerializable(explicitToJson: true)
class UserNotificationRecord {
  String? text;
  @EpochDateTimeConverter()
  final DateTime timeToNotificate;
  UserNotificationRecord(this.text, this.timeToNotificate);
  factory UserNotificationRecord.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationRecordToJson(this);
}
