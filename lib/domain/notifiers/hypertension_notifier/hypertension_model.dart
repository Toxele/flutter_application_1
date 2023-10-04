import 'package:flutter_application_1/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../weather_notifier/weather.dart';

part 'hypertension_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HypertensionModel {
  // поля значений, которые вводят пользователь, возможно сюда добавится дата и время
  final int? sys;
  final int? dia;
  final int? pulse;
  final Weather? weather;
  @EpochDateTimeConverter()
  final DateTime timeOfRecord; // todo: это время снятия показаний?

  int get uuid => timeOfRecord.millisecondsSinceEpoch;

  const HypertensionModel({
    this.sys,
    this.dia,
    this.pulse,
    this.weather,
    required this.timeOfRecord,
  });

  factory HypertensionModel.fromJson(Map<String, dynamic> json) =>
      _$HypertensionModelFromJson(json);

  Map<String, dynamic> toJson() => _$HypertensionModelToJson(this);
}
