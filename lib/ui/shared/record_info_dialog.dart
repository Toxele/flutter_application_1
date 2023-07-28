import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/model/user_record.dart';
import 'package:provider/provider.dart';

import '../../data/class_instances.dart';

class RecordInfoDialog extends StatefulWidget {
  const RecordInfoDialog({super.key});
  @override
  State<RecordInfoDialog> createState() => _RecordInfoDialogState();
}

class _RecordInfoDialogState extends State<RecordInfoDialog> {
  late final UserRecord record;
  @override
  Widget build(BuildContext context) {
    OpenInstances open = context.read<OpenInstances>();
    record = open.record!;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: <Widget>[
            const Card(
              child: Text('Данные измерения', style: TextStyle(fontSize: 20),),
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
