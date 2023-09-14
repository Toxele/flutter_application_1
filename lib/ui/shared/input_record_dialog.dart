import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;
import 'package:flutter_application_1/domain/user_records_notifier/user_records_notifier.dart';
import 'package:flutter_application_1/domain/weather_notifier/weather_notifier.dart';
import 'package:provider/provider.dart';

import '../../domain/weather_notifier/weather.dart';
import '../../utils/text_field_pattern.dart';

class _InputRecord {
  String sys = '';
  String dia = '';
  String pulse = '';
  String temperature = '';
  String pressure = '';
  String cloudiness = '';
}

class InputRecordDialog extends StatelessWidget {
  const InputRecordDialog({super.key, required this.onDone});

  final void Function({
    int sys,
    int dia,
    int pulse,
    required Weather weather,
  }) onDone;

  @override
  Widget build(BuildContext context) {
    return Provider<_InputRecord>(
      create: (_) => _InputRecord(),
      builder: (context, child) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final record = context.read<_InputRecord>();
              final userStatus = context.read<UserRecordsNotifier>();

              final sys =
                  int.tryParse(record.sys) ?? default_values.defaultZero;
              final dia =
                  int.tryParse(record.dia) ?? default_values.defaultZero;
              final pulse =
                  int.tryParse(record.pulse) ?? default_values.defaultZero;
              final temperature = double.tryParse(record.temperature);
              final pressure = double.tryParse(record.pressure);
              final cloudiness = double.tryParse(record.cloudiness);
              if (await userStatus.acceptRecord(sys, dia, pulse)) {
                onDone.call(
                  sys: sys,
                  dia: dia,
                  pulse: pulse,
                  weather: Weather(
                    temperature: temperature,
                    pressure: pressure,
                    cloudiness: cloudiness,
                  ),
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Icon(Icons.done),
          ),
          body: Consumer<WeatherNotifier>(
            builder: (context, weatherNotifier, _) {
              final Weather? weather = weatherNotifier.weather;
              final record = context.read<_InputRecord>();
              //TODO : покрутить этот момент // может функцию создать с именованными параметрами? 
              record.temperature = weather?.temperature.toString() ?? '';
              record.pressure = weather?.pressure.toString() ?? '';
              record.cloudiness = weather?.cloudiness.toString() ?? '';

              return ListView(
                children: [
                  TextFieldPattern(
                    onEdit: (String value) => record.sys = value,
                    value: "",
                    valueName: 'Давление, SYS',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) => record.dia = value,
                    value: "",
                    valueName: 'Давление, DIA',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) => record.pulse = value,
                    value: "",
                    valueName: 'Пульс',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) => record.temperature = value,
                    value: weather?.temperature.toString() ?? _defaultText,
                    valueName: 'Температура в градусах Цельсия',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) => record.pressure = value,
                    value: weather?.pressure.toString() ?? _defaultText,
                    valueName: 'Давление, мм. рт. ст.',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) => record.cloudiness = value,
                    value: weather?.cloudiness.toString() ?? _defaultText,
                    valueName: 'Облачность, %',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static const _defaultText = "Данные ещё загружаются";
}
