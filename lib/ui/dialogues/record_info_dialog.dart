import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';
import 'package:provider/provider.dart';

//todo переименовать все классы в соответствии с hypertension
class HypertensionInfo extends StatelessWidget {
  const HypertensionInfo({super.key});
  @override
  Widget build(BuildContext context) {
    final record = context.watch<UserRecordToDisplay>().value;

    final pressure = record.weather?.pressure;
    final cloudiness = record.weather?.cloudiness;

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
              height: 1,
              color: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                const Spacer(),
                const Text(
                  'Давление: ',
                  style: sharedTextStyle,
                ),
                Text(
                  '${record.sys}/${record.dia}',
                  style: sharedTextStyle,
                ),
                const Spacer(),
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                const Text(
                  'Пульс, уд/мин: ',
                  style: sharedTextStyle,
                ),
                Text(
                  '${record.pulse}',
                  style: sharedTextStyle,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.red,
            ),
            const SizedBox(
              height: 10,
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
              color: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  const Spacer(),
                  const Text(
                    'Температура в градусах Цельсия: ',
                    style: sharedTextStyle,
                  ),
                  Text(
                    '${record.weather?.temperature}',
                    style: sharedTextStyle,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  const Spacer(),
                  const Text(
                    'Облачность: ',
                    style: sharedTextStyle,
                  ),
                  Text(
                    '${record.weather?.cloudiness}%',
                    style: sharedTextStyle,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  const Spacer(),
                  const Text(
                    'Атмосферное давление, мм. рт. ст.',
                    style: sharedTextStyle,
                  ),
                  Text(
                    '${record.weather?.pressure}',
                    style: sharedTextStyle,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
