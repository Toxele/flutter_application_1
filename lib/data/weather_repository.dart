import 'package:weather_pack/weather_pack.dart';

import '../domain/notifiers/weather_notifier/weather.dart';

class WeatherRepository {
  WeatherRepository({
    WeatherService? weatherService,
  }) : _weatherService = weatherService ??
            WeatherService(_apiKey, language: WeatherLanguage.russian);

  static const _apiKey = String.fromEnvironment('WEATHER_APIKEY');

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
