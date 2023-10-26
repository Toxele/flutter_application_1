import 'package:flutter_application_1/utils/date_time_converter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show RepeatInterval;
import 'package:json_annotation/json_annotation.dart';

part 'event_notification.g.dart';

extension RepeatIntervalLabel on RepeatInterval {
  String get label => switch (this) {
        RepeatInterval.everyMinute => 'Поминутно',
        RepeatInterval.hourly => 'Каждый час',
        RepeatInterval.daily => 'Каждый день',
        RepeatInterval.weekly => 'Каждую неделю',
      };
}

/// todo переделать на freezed
@JsonSerializable(explicitToJson: true)
class EventNotification {
  // todo
  //  взять время из настоящего uuid а не то, что сейчас
  //  String get _uuid => const UuidV7().generate();
  int get uuid => time.millisecond;

  final String text;

  @EpochDateTimeConverter()
  final DateTime time;

  final bool isActive;

  final RepeatInterval? repeatInterval;

  const EventNotification({
    required this.text,
    required this.time,
    this.repeatInterval,
    this.isActive = true,
  });

  factory EventNotification.fromJson(Map<String, dynamic> json) =>
      _$EventNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$EventNotificationToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventNotification &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          time == other.time &&
          isActive == other.isActive;

  @override
  int get hashCode => text.hashCode ^ time.hashCode ^ isActive.hashCode;

  EventNotification copyWith({
    int? uuid,
    String? text,
    DateTime? time,
    bool? isActive,
  }) {
    return EventNotification(
      text: text ?? this.text,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
    );
  }
}
