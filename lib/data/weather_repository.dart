import 'package:flutter_application_1/domain/weather/weather.dart';
import 'package:weather_pack/weather_pack.dart';

class WeatherRepository {
  WeatherRepository({
    WeatherService? weatherService,
  }) : _weatherService = weatherService ??
            WeatherService(_apiKey, language: WeatherLanguage.russian);

  // todo убрать в ближайшее время, использовать dart define and String.fromEnvironment
  static const _apiKey = 'b890077fb67d8ea8060faed793c9c9c4';

  final WeatherService _weatherService;

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final WeatherCurrent currently =
        await _weatherService.currentWeatherByLocation(
      latitude: latitude,
      longitude: longitude,
    );

    final temp = currently.temp;

    final Weather weather = Weather(
      temperature: temp != null ? Temp.celsius.value(temp) : null,
      pressure: currently.pressure,
      cloudiness: currently.cloudiness,
    );
    return weather;
  }
}
