import 'package:flutter_application_1/domain/weather/weather_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UserRecord {
  // поля значений, которые вводят пользователь, возможно сюда добавится дата и время
  final int? sys;
  final int? dia;
  final int? pulse;
  final Weather? weather;
// DateTime timeOfRecord;
  const UserRecord(this.sys, this.dia, this.pulse, this.weather);
  factory UserRecord.fromJson(Map<String, dynamic> jsonMap) {
    return UserRecord(
      jsonMap["sys"] as int,
      jsonMap["dia"] as int,
      jsonMap["pulse"] as int,
      jsonMap["weather"] as Weather,
      //  jsonMap["time"] as DateTime,
    );
  }

  Map toJson() => {"sys": sys, "pulse": pulse, "dia": dia, "weather": weather};
}
