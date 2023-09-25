import 'package:flutter_application_1/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_notification.g.dart';

/// todo переделать на freezed
@JsonSerializable(explicitToJson: true)
class EventNotification {
  final int uuid;

  // todo взять время а не то, что сейчас
  // int get uuidAsTime => uuid;

  final String text;

  @EpochDateTimeConverter()
  final DateTime time;

  final bool isActive;

  const EventNotification({
    required this.uuid,
    required this.text,
    required this.time,
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
          uuid == other.uuid &&
          text == other.text &&
          time == other.time &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      uuid.hashCode ^ text.hashCode ^ time.hashCode ^ isActive.hashCode;

  EventNotification copyWith({
    int? uuid,
    String? text,
    DateTime? time,
    bool? isActive,
  }) {
    return EventNotification(
      uuid: uuid ?? this.uuid,
      text: text ?? this.text,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
    );
  }
}
