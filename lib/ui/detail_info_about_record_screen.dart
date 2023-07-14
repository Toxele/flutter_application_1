import 'package:flutter/material.dart';

class DetailRecordInfoScreen extends StatefulWidget {
  const DetailRecordInfoScreen({super.key});

  @override
  State<DetailRecordInfoScreen> createState() => DetailRecordInfoScreenState();
}

class DetailRecordInfoScreenState extends State<DetailRecordInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: ListView(
        children: const <Widget>[
          Text('Давление, Sys: '),
          Text('Давление, Dia: '),
          Text('Пульс: '),
          Text('Температура: '),
          Text('Атмосферное давление: '),
          Text('Облачность: '),
        ],
      ),
    );
  }
}
