import 'package:flutter/material.dart';

class SetUpSharedPreferencesScreen extends StatefulWidget {
  const SetUpSharedPreferencesScreen({super.key});

  @override
  State<SetUpSharedPreferencesScreen> createState() =>
      _SetUpSharedPreferencesScreenState();
}

class _SetUpSharedPreferencesScreenState
    extends State<SetUpSharedPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Center(child: Text('Укажите ваш пол')),
        SizedBox(
          height: 10,
        ),
        Center(child: Text('Введите ваш вес')),
      ],
    );
  }
}
