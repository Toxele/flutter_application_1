import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/domain/weather/weather_notifier.dart';
import 'package:provider/provider.dart';

import '../../domain/weather/weather.dart';

class InputRecordDialog extends StatefulWidget {
  const InputRecordDialog({super.key, required this.onDone});

  final Function({int sys, int dia, int pulse, required Weather weather})
      onDone;

  @override
  State<InputRecordDialog> createState() => _InputRecordDialogState();
}

class _InputRecordDialogState extends State<InputRecordDialog> {
  late final TextEditingController sysController;
  late final TextEditingController diaController;
  late final TextEditingController pulseController;
  late final TextEditingController temperatureController;
  late final TextEditingController pressureController;
  late final TextEditingController cloudinessController;
  late final UserStatusController userStatus;
  late final WeatherNotifier weatherController;
  late final Weather? weather;
  @override
  void initState() {
    super.initState();
    weatherController = context.read<WeatherNotifier>();
    userStatus = context.read<UserStatusController>();
    weather = weatherController.weather;
    sysController = TextEditingController();
    diaController = TextEditingController();
    pulseController = TextEditingController();
    temperatureController = TextEditingController();
    pressureController = TextEditingController();
    cloudinessController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    sysController.dispose();
    diaController.dispose();
    pulseController.dispose();
    temperatureController.dispose();
    pressureController.dispose();
    cloudinessController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final sys =
                int.tryParse(sysController.text) ?? default_values.defaultZero;
            final dia =
                int.tryParse(diaController.text) ?? default_values.defaultZero;
            final pulse = int.tryParse(pulseController.text) ??
                default_values.defaultZero;
            final temperature = double.tryParse(temperatureController.text);
            final pressure = double.tryParse(pressureController.text);
            final cloudiness = double.tryParse(cloudinessController.text);
            if (await userStatus.acceptRecord(sys, dia, pulse)) {
              widget.onDone.call(
                sys: sys,
                dia: dia,
                pulse: pulse,
                weather: Weather(
                    temperature: temperature,
                    pressure: pressure,
                    cloudiness: cloudiness),
              );

              Navigator.of(context).pop();
            }
          },
          child: const Icon(Icons.done),
        ),
        body: ListenableBuilder(
            listenable: weatherController,
            builder: (context, child) {
              return ListView(
                children: [
                  TextFieldPattern(
                      value: "",
                      valueName: 'Давление, SYS',
                      textEditingController: sysController),
                  TextFieldPattern(
                      value: "",
                      valueName: 'Давление, DIA',
                      textEditingController: diaController),
                  TextFieldPattern(
                      value: weather?.temperature,
                      valueName: 'Температура в градусах Цельсия',
                      textEditingController: temperatureController),
                  TextFieldPattern(
                      value: weather?.pressure,
                      valueName: 'Давление, мм. рт. ст.',
                      textEditingController: pressureController),
                  TextFieldPattern(
                      value: weather?.cloudiness,
                      valueName: 'Облачность, %',
                      textEditingController: cloudinessController),
                  // textFieldPattern(context, "", 'Давление, DIA', diaController),
                  //textFieldPattern(context, weatherController.weather?.temperature, 'Температура в градусах Цельсия', temperatureController),
                  //textFieldPattern(context, weatherController.weather?.pressure, 'Давление, мм. рт. ст.', pressureController),
                  /*textFieldPattern(
                      context,
                      weatherController.weather?.cloudiness,
                      'Облачность',
                      cloudinessController),*/
                ],
              );
            }),
      ),
    );
  }

  Widget textFieldPattern(BuildContext context, dynamic value, String valueName,
      TextEditingController textEditingController) {
    // ignore: parameter_assignments
    value = value ??
        "Данные ещё загружаются, вы можете ввести их самостоятельно при необходимости";
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Center(
          child: Text(
            valueName,
            style: TextStyle(fontSize: 20),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: '$value',
          ),
          controller: textEditingController,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class TextFieldPattern extends StatelessWidget {
  final TextEditingController textEditingController;
  final dynamic value;
  final String valueName;
  const TextFieldPattern({
    super.key,
    required this.textEditingController,
    required this.value,
    required this.valueName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Center(
          child: Text(
            valueName,
            style: TextStyle(fontSize: 20),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: '$value',
          ),
          controller: textEditingController,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
