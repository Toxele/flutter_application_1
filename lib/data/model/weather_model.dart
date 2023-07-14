import 'package:json_annotation/json_annotation.dart';
import 'package:weather_pack/weather_pack.dart';
class WeatherRepository {
  static const _apiKey = 'b890077fb67d8ea8060faed793c9c9c4';
  final wService = WeatherService(_apiKey, language: WeatherLanguage.russian);
  Future<Weather> getWeather() async {
    final WeatherCurrent currently = await wService.currentWeatherByLocation(latitude: 10, longitude: 10);
    final Weather weather = Weather(temperature: currently.temp, pressure: currently.pressure, cloudiness: currently.cloudiness);
    return weather;
  }

}

@JsonSerializable(explicitToJson: true)
class Weather {
  double? temperature;
  double? pressure;
  double? cloudiness;
  // TODO: add more fields
  Weather({this.temperature, this.pressure, this.cloudiness});
}
