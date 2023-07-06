import 'package:flutter/material.dart';
import 'package:flutter_application_1/default_values.dart' as default_values;

class MyDialog extends StatefulWidget {
  const MyDialog({super.key, required this.onDone});

  final Function(int sys, int dia, int pulse) onDone;

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late TextEditingController sysController;
  late TextEditingController diaController;
  late TextEditingController pulseController;
  @override
  initState() {
    super.initState();
    sysController = TextEditingController();
    diaController = TextEditingController();
    pulseController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    sysController.dispose();
    diaController.dispose();
    pulseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int sys =
                int.tryParse(sysController.text) ?? default_values.default_zero;
            int dia =
                int.tryParse(diaController.text) ?? default_values.default_zero;
            int pulse = int.tryParse(pulseController.text) ??
                default_values.default_zero;
            if (sys > 90 &&
                sys < 170 &&
                dia > 70 &&
                dia < 140 &&
                pulse > 50 &&
                pulse < 160) {
              widget.onDone.call(sys, dia, pulse);

              Navigator.of(context).pop();
            }
          },
          child: Icon(Icons.done),
        ),
        body: Column(children: [
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              'Давление, SYS',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextField(
            controller: sysController,
          ),
           const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              'Давление, DIA',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextField(
            controller: diaController,
          ),
           const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              'Пульс',
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextField(
            controller: pulseController,
          ),
        ]),
      ),
    );
  }
}
