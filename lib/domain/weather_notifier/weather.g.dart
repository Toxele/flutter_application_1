// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      temperature: (json['temp'] as num?)?.toDouble() ?? 12.0,
      pressure: (json['pressure'] as num?)?.toDouble(),
      cloudiness: (json['cloudiness'] as num?)?.toDouble() ?? 2,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'temp': instance.temperature,
      'pressure': instance.pressure,
      'cloudiness': instance.cloudiness,
    };
