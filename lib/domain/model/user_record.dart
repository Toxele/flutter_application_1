import 'package:flutter_application_1/domain/weather/weather.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_record.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRecord {
  // поля значений, которые вводят пользователь, возможно сюда добавится дата и время
  final int? sys;
  final int? dia;
  final int? pulse;
  final Weather? weather;
// DateTime timeOfRecord;
  const UserRecord({
    this.sys,
    this.dia,
    this.pulse,
    this.weather,
  });

  factory UserRecord.fromJson(Map<String, dynamic> json) =>
      _$UserRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserRecordToJson(this);
}
