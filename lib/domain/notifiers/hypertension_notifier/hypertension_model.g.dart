// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypertension_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HypertensionModel _$HypertensionModelFromJson(Map<String, dynamic> json) =>
    HypertensionModel(
      sys: json['sys'] as int?,
      dia: json['dia'] as int?,
      pulse: json['pulse'] as int?,
      weather: json['weather'] == null
          ? null
          : Weather.fromJson(json['weather'] as Map<String, dynamic>),
      timeOfRecord:
          const EpochDateTimeConverter().fromJson(json['timeOfRecord'] as int),
    );

Map<String, dynamic> _$HypertensionModelToJson(HypertensionModel instance) =>
    <String, dynamic>{
      'sys': instance.sys,
      'dia': instance.dia,
      'pulse': instance.pulse,
      'weather': instance.weather?.toJson(),
      'timeOfRecord':
          const EpochDateTimeConverter().toJson(instance.timeOfRecord),
    };
