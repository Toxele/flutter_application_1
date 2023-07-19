import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;
import 'package:flutter_application_1/domain/controllers.dart' as controllers;
import 'package:flutter_application_1/domain/weather/weather_notifier.dart';

import '../../domain/weather/weather_class.dart';

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
  late final WeatherNotifier weatherController;
  @override
  void initState() {
    super.initState();
    weatherController = controllers.weatherController;
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
          onPressed: () {
            final sys =
                int.tryParse(sysController.text) ?? default_values.defaultZero;
            final dia =
                int.tryParse(diaController.text) ?? default_values.defaultZero;
            final pulse = int.tryParse(pulseController.text) ??
                default_values.defaultZero;
            final temperature = double.tryParse(temperatureController.text);
            final pressure = double.tryParse(pressureController.text);
            final cloudiness = double.tryParse(cloudinessController.text);
            if (sys > 90 &&
                sys < 170 &&
                dia > 70 &&
                dia < 140 &&
                pulse > 50 &&
                pulse < 160) {
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
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Давление, SYS',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: sysController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Давление, DIA',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: diaController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Пульс',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: pulseController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Температура',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText:
                            '${(weatherController.weather?.temperature)}'),
                    controller: temperatureController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Давление, мм. рт. ст.',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '${(weatherController.weather?.pressure)}'),
                    controller: pressureController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Облачность',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '${(weatherController.weather?.cloudiness)}'),
                    controller: cloudinessController,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
