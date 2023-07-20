// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRecord _$UserRecordFromJson(Map<String, dynamic> json) => UserRecord(
      sys: json['sys'] as int?,
      dia: json['dia'] as int?,
      pulse: json['pulse'] as int?,
      weather: json['weather'] == null
          ? null
          : Weather.fromJson(json['weather'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRecordToJson(UserRecord instance) =>
    <String, dynamic>{
      'sys': instance.sys,
      'dia': instance.dia,
      'pulse': instance.pulse,
      'weather': instance.weather?.toJson(),
    };
