import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Weather {
  final double? temperature;
  final double? pressure;
  final double? cloudiness;
  // TODO: add more fields
  const Weather({this.temperature, this.pressure, this.cloudiness = 2});
}
