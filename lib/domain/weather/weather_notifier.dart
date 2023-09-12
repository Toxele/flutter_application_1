import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/geolocation_repository.dart';
import 'package:flutter_application_1/data/weather_repository.dart';
import 'package:flutter_application_1/domain/weather/weather.dart';
import 'package:geolocator/geolocator.dart';

class WeatherNotifier extends ChangeNotifier {
  WeatherNotifier({
    required this.weatherRepository,
    required this.geolocationRepository,
  }) {
    getWeather();
  }

  final WeatherRepository weatherRepository;
  final GeolocationRepository geolocationRepository;

  Weather? weather;

  bool isLoading = true;

  Future<void> getWeather() async {
    isLoading = true;
    notifyListeners();
    final Position pos = await geolocationRepository.determinePosition();
    weather = await weatherRepository.getWeather(
      latitude: pos.latitude,
      longitude: pos.longitude,
    );
    isLoading = false;
    notifyListeners();
  }
}
