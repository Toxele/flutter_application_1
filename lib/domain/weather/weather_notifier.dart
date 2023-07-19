import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/geolocation_repository.dart';
import 'package:flutter_application_1/domain/weather/weather_class.dart';
import 'package:flutter_application_1/domain/weather/weather_model.dart';
//import 'package:geolocator/geolocator.dart';

class WeatherNotifier extends ChangeNotifier {
  WeatherNotifier({
    required this.weatherRepository,
   // required this.geolocationRepository,
  }) {
    getWeather();
  }

  final WeatherRepository weatherRepository;
//  final GeolocationService geolocationRepository;

  Weather? weather;

  Future<void> getWeather() async {
  //  final Position pos = await geolocationRepository.determinePosition();
    weather = await weatherRepository.getWeather(
      latitude: 10, //pos.latitude,
      longitude: 10,//pos.longitude,
    );
    notifyListeners();
  }
}
