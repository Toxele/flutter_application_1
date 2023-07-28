import 'package:flutter/material.dart';

class SetUpSharedPreferencesScreen extends StatefulWidget {
  const SetUpSharedPreferencesScreen({super.key});

  @override
  State<SetUpSharedPreferencesScreen> createState() =>
      _SetUpSharedPreferencesScreenState();
}

class _SetUpSharedPreferencesScreenState
    extends State<SetUpSharedPreferencesScreen> {
  Widget build(BuildContext context) {
    return Stepper(
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
          children: <Widget>[
            TextButton(
              onPressed: details.onStepContinue,
              child: Text('Continue to Step ${details.stepIndex + 1}'),
            ),
            TextButton(
              onPressed: details.onStepCancel,
              child: Text('Back to Step ${details.stepIndex - 1}'),
            ),
          ],
        );
      },
      steps: const <Step>[
        Step(
          title: Text('A'),
          content: SizedBox(
            width: 100.0,
            height: 100.0,
          ),
        ),
        Step(
          title: Text('B'),
          content: SizedBox(
            width: 100.0,
            height: 100.0,
          ),
        ),
      ],
    );
  }
}
