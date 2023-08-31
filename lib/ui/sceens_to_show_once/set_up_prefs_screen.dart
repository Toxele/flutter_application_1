
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:provider/provider.dart';

class SetUpSharedPreferencesScreen extends StatefulWidget {
  const SetUpSharedPreferencesScreen({super.key});

  @override
  State<SetUpSharedPreferencesScreen> createState() =>
      _SetUpSharedPreferencesScreenState();
}

class _SetUpSharedPreferencesScreenState
    extends State<SetUpSharedPreferencesScreen> {
  @override
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          title: const Text('Укажите ваш пол'),
          content: Column(
            children: [
              // TODO: add radio
              const RadioListTileUser(),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Продолжить'),
              ),
            ],
          ),
        ),
        const Step(
          title: Text('Укажите ваш вес'),
          content: Text('12345'),
        ),
      ],
    );
  }
}

enum User { women, men }

class RadioListTileUser extends StatefulWidget {
  const RadioListTileUser({super.key});

  @override
  State<RadioListTileUser> createState() => _RadioListTileUserState();
}

class _RadioListTileUserState extends State<RadioListTileUser> {
  User? _character = User.men;

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageRepository>();
    return Column(
      children: <Widget>[
        RadioListTile<User>(
          title: const Text('Men'),
          value: User.men,
          groupValue: _character,
          onChanged: (User? value) {
            setState(() {
              _character = value;
              storage.storage.setBool('IsMan', true);
            });
          },
        ),
        RadioListTile<User>(
          title: const Text('Women'),
          value: User.women,
          groupValue: _character,
          onChanged: (User? value) {
            setState(() {
              _character = value;
              storage.storage.setBool('IsMan', false);
            });
          },
        ),
      ],
    );
  }
}
