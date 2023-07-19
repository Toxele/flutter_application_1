import 'package:flutter/material.dart';

class RecordInfoDialog extends StatefulWidget {
  const RecordInfoDialog({super.key});

  @override
  State<RecordInfoDialog> createState() => _RecordInfoDialogState();
}

class _RecordInfoDialogState extends State<RecordInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: const <Widget>[
            Card(child: Text('Данные измерения')),
            Card(
              child: Row(
                children: <Widget>[
                  Text('Давление'),
                  Spacer(),
                  Text('120/80'),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  Text('Пульс, уд/мин'),
                  Spacer(),
                  Text('80'),
                ],
              ),
            ),
            Card(
              child: Card(child: Text('Метеоусловия'),),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  Text('Температура в градусах Цельсия'),
                  Spacer(),
                  Text('30'),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  Text('Облачность, %'),
                  Spacer(),
                  Text('30'),
                ],
              ),
            ),
            Card(
              child: Row(
                children: <Widget>[
                  Text('Атмосферное давление, мм. рт. ст.'),
                  Spacer(),
                  Text('785'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
