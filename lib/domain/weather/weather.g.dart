// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      temperature: (json['temperature'] as num?)?.toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble(),
      cloudiness: (json['cloudiness'] as num?)?.toDouble() ?? 2,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'temperature': instance.temperature,
      'pressure': instance.pressure,
      'cloudiness': instance.cloudiness,
    };
