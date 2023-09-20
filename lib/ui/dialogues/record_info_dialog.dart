import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifications/notifications_presenter.dart';

//todo переименовать все классы в соответствии с hypertension
class RecordInfoDialog extends StatefulWidget {
  const RecordInfoDialog({super.key});
  @override
  State<RecordInfoDialog> createState() => _RecordInfoDialogState();
}

class _RecordInfoDialogState extends State<RecordInfoDialog> {
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

            /// todo: добавить другие тайлы
            _RecordTile(
              name: 'Облачность: ',
              value: cloudiness != null ? '${cloudiness.toString()}%' : '–',
            ),
            _RecordTile(
              name: 'Атмосферное давление, мм. рт. ст.',
              value: pressure != null ? pressure.toString() : '–',
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({super.key, required this.name, required this.value});

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
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
