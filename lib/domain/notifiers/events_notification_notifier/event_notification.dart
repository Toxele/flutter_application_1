import 'package:flutter_application_1/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_notification.g.dart';

@JsonSerializable(explicitToJson: true)
class EventNotification {
  String? text;
  @EpochDateTimeConverter()
  final DateTime timeToNotificate;
  bool? notificateThis;
  EventNotification(
      {this.text, required this.timeToNotificate, this.notificateThis});
  factory EventNotification.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationRecordToJson(this);
}
