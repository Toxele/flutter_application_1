import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/class_instances.dart';

class RecordInfoDialog extends StatefulWidget {
  const RecordInfoDialog({super.key});
  @override
  State<RecordInfoDialog> createState() => _RecordInfoDialogState();
}

class _RecordInfoDialogState extends State<RecordInfoDialog> {
  @override
  Widget build(BuildContext context) {
    final record = context.watch<UserRecordToDisplay>().value;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: <Widget>[
            const Card(
              child: Text(
                'Данные измерения',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const Text('Давление'),
                  const Spacer(),
                  Text('${record.sys}/${record.dia}'),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const Text('Пульс, уд/мин'),
                  const Spacer(),
                  Text('${record.pulse}'),
                ],
              ),
            ),
            const Card(
              child: Text('Метеоусловия'),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const Text('Температура в градусах Цельсия'),
                  const Spacer(),
                  Text('${record.weather?.temperature}'),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const Text('Облачность, %'),
                  const Spacer(),
                  Text('${record.weather?.cloudiness}'),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  const Text('Атмосферное давление, мм. рт. ст.'),
                  const Spacer(),
                  Text('${record.weather?.pressure}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
