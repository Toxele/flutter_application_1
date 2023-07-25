import 'package:flutter_application_1/domain/weather/weather.dart';
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
      temperature:
          currently.temp != null ? Temp.celsius.value(currently.temp!) : null,
      pressure: currently.pressure,
      cloudiness: currently.cloudiness,
    );
    return weather;
  }
}
