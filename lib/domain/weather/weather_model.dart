import 'package:flutter_application_1/data/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_pack/weather_pack.dart';

class WeatherRepository {
  WeatherRepository();

  static const _apiKey = 'b890077fb67d8ea8060faed793c9c9c4';
  final wService = WeatherService(_apiKey, language: WeatherLanguage.russian);
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final WeatherCurrent currently = await wService.currentWeatherByLocation(
      latitude: latitude,
      longitude: longitude,
    );

    final Weather weather = Weather(
        temperature: currently.temp != null ? currently.temp! - 273 : null,
        pressure: currently.pressure,
        cloudiness: currently.cloudiness);
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
