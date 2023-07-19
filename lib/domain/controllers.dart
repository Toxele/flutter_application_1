import 'package:flutter_application_1/data/geolocation_repository.dart';
import 'package:flutter_application_1/domain/weather/weather_model.dart';
import 'package:flutter_application_1/domain/weather/weather_notifier.dart';

//const _geolocationRepo = GeolocationService();
final _weatherRepository = WeatherRepository();

final weatherController = WeatherNotifier(
 // geolocationRepository: _geolocationRepo,
  weatherRepository: _weatherRepository,
);
