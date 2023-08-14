import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/domain/weather/weather_notifier.dart';
import 'package:provider/provider.dart';

import '../../domain/weather/weather.dart';

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
              final userStatus = context.read<UserStatusNotifier>();

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
              record.temperature = weather?.temperature.toString() ?? '';
              record.cloudiness = weather?.cloudiness.toString() ?? '';
              record.pressure = weather?.pressure.toString() ?? '';

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

class TextFieldPattern extends StatelessWidget {
  const TextFieldPattern({
    super.key,
    required this.onEdit,
    required this.value,
    required this.valueName,
  });

  final String value;
  final String valueName;
  final Function(String value) onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Center(
          child: Text(
            valueName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: value,
          ),
          // todo: сделать в качестве параметров виджета, потому что
          // каждой формочке нужны свои настройки
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          onChanged: onEdit,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
