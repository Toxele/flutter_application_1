import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/domain/weather/weather_notifier.dart';
import 'package:provider/provider.dart';

import '../../domain/weather/weather.dart';
import '../home.dart';

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

  final Function({
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
              final userStatus = context.read<UserStatusController>();

              final sys =
                  int.tryParse(record.sys) ?? default_values.defaultZero;
              final dia =
                  int.tryParse(record.dia) ?? default_values.defaultZero;
              final pulse =
                  int.tryParse(record.pulse) ?? default_values.defaultZero;
              final temperature = double.tryParse(record.temperature);
              final pressure = double.tryParse(record.pressure);
              final cloudiness = double.tryParse(record.cloudiness);

              final navigator = Navigator.of(context);

              /// todo: тут возникает ошибка, но это уже другая история
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

                navigator.pop();
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
                    onEdit: (String value) =>
                        context.read<_InputRecord>().sys = value,
                    value: "",
                    valueName: 'Давление, SYS',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) =>
                        context.read<_InputRecord>().dia = value,
                    value: "",
                    valueName: 'Давление, DIA',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) =>
                        context.read<_InputRecord>().pulse = value,
                    value: "",
                    valueName: 'Пульс',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) =>
                        context.read<_InputRecord>().temperature = value,
                    value: weather?.temperature.toString() ?? _defaultText,
                    valueName: 'Температура в градусах Цельсия',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) =>
                        context.read<_InputRecord>().pressure = value,
                    value: weather?.pressure.toString() ?? _defaultText,
                    valueName: 'Давление, мм. рт. ст.',
                  ),
                  TextFieldPattern(
                    onEdit: (String value) =>
                        context.read<_InputRecord>().cloudiness = value,
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

class TextFieldPattern extends StatefulWidget {
  final String value;
  final String valueName;
  final Function(String value) onEdit;

  const TextFieldPattern({
    super.key,
    required this.onEdit,
    required this.value,
    required this.valueName,
  });

  @override
  State<TextFieldPattern> createState() => _TextFieldPatternState();
}

class _TextFieldPatternState extends State<TextFieldPattern> {
  late final TextEditingController textController;
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Center(
          child: Text(
            widget.valueName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: widget.value,
          ),
          controller: textController,
          onChanged: widget.onEdit,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
