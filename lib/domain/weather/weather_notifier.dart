import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/domain/weather/weather_model.dart';

class WeatherNotifier extends ChangeNotifier {
  late final WeatherRepository _repository;
  Weather? weather;
  WeatherNotifier() {
    _repository = WeatherRepository();
    getWeather();
  }
  Future<void> getWeather() async {
    weather = await _repository.getWeather();
    notifyListeners();
  }
}