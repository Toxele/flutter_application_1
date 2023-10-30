import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/ui/home/home_presenter.dart';
import 'package:flutter_application_1/utils/text_field_pattern.dart';
import 'package:provider/provider.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int _index = 0;
  double _weight = 0.0;
  double _height = 0.0;
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
        if (_index <= 1) {
          setState(() {
            _index += 1;
          });
        } else {
          context
              .read<HomeStatePresenter>()
              .finishStepper(weight: _weight, height: _height);
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        const Step(
          title: Text('Укажите ваш пол'),
          content: RadioListTileUser(),
        ),
        Step(
          title: const Text('Укажите ваш вес в килограммах'),
          content: TextFieldPattern(
            onEdit: (String value) =>
                _weight = double.tryParse(value) ?? StorageStore.weight,
            value: StorageStore.weight.toString(),
            valueName: '',
          ),
        ),
        Step(
          title: const Text('Укажите ваш рост в сантиметрах'),
          content: TextFieldPattern(
            onEdit: (String value) =>
                _height = double.tryParse(value) ?? StorageStore.height,
            value: StorageStore.height.toString(),
            valueName: '',
          ),
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
          title: const Text('Мужской'),
          value: User.men,
          groupValue: _character,
          onChanged: (User? value) {
            setState(() {
              _character = value;
              storage.setBool(StorageStore.isManKey, true);
            });
          },
        ),
        RadioListTile<User>(
          title: const Text('Женский'),
          value: User.women,
          groupValue: _character,
          onChanged: (User? value) {
            setState(() {
              _character = value;
              storage.setBool(StorageStore.isManKey, false);
            });
          },
        ),
      ],
    );
  }
}
