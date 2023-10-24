import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';
import 'package:provider/provider.dart';

//todo переименовать все классы в соответствии с hypertension
class HypertensionInfo extends StatelessWidget {
  const HypertensionInfo({super.key});
  @override
  Widget build(BuildContext context) {
    final record = context.watch<HypertensionModel>();

    final pressure = record.weather?.pressure;
    final cloudiness = record.weather?.cloudiness;
    final temperature = record.weather?.temperature;
    final pulse = record.pulse;
    final dia = record.dia;
    final sys = record.sys;
    const TextStyle sharedTextStyle = TextStyle(fontSize: 20);
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(title: const Text('Ваша запись')),
        body: ListView(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(20)),
                Spacer(),
                Text(
                  'Данные измерения',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Padding(padding: EdgeInsets.all(20)),
              ],
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Theme.of(context).primaryColorLight,
            ),
            const SizedBox(
              height: 10,
            ),
            _RecordTile(name: 'Давление:', value: '$sys/$dia'),
            _RecordTile(name: 'Пульс, уд/мин:', value: pulse.toString()),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Theme.of(context).primaryColorLight,
            ),

            const Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(20)),
                Spacer(),
                Text(
                  'Метеоусловия',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Padding(padding: EdgeInsets.all(20)),
              ],
            ),
            Container(
              width: double.infinity,
              height: 10,
              color: Theme.of(context).primaryColorLight,
            ),
            const SizedBox(
              height: 10,
            ),
            _RecordTile(
                name: 'Температура, в градусах цельсия:',
                value: temperature != null ? '$temperature' : '-'),

            /// todo: добавить другие тайлы
            _RecordTile(
              name: 'Облачность: ',
              value: cloudiness != null ? '$cloudiness%' : '–',
            ),
            _RecordTile(
              name: 'Атмосферное давление, мм. рт. ст:',
              value: pressure != null ? pressure.toString() : '–',
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.name, required this.value});

  final String name;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                name,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value != null ? value.toString() : '–',
              style: theme.textTheme.titleLarge, // labelMedium
            ),
          ],
        ),
      ),
    );
  }
}
