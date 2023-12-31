import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  // todo: это для теста было
  @JsonKey(name: 'temp', defaultValue: 12.0)
  final double? temperature;
  final double? pressure;
  final double? cloudiness;
  // TODO: add more fields
  const Weather({this.temperature, this.pressure, this.cloudiness = 2});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
