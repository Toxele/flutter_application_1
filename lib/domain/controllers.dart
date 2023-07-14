import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/model/weather_model.dart';

class WeatherController extends ChangeNotifier
{
  final WeatherRepository repository = WeatherRepository();
  Weather? weather;
  WeatherController()
  {
    getWeather();
  }
  void getWeather() async
  {
    weather = await repository.getWeather();
    notifyListeners();
  }
}