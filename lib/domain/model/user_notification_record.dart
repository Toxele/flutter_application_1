import 'package:flutter_application_1/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_notification_record.g.dart';

// todo rename -- EventNotification
@JsonSerializable(explicitToJson: true)
class UserNotificationRecord {
  String? text;
  @EpochDateTimeConverter()
  final DateTime timeToNotificate;
  bool? notificateThis;
  UserNotificationRecord(
      {this.text, required this.timeToNotificate, this.notificateThis});
  factory UserNotificationRecord.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationRecordToJson(this);
}
