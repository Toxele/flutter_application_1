import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart'
    as default_values;

class MyDialog extends StatefulWidget {
  const MyDialog({super.key, required this.onDone});

  final Function({int sys, int dia, int pulse}) onDone;

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late TextEditingController sysController;
  late TextEditingController diaController;
  late TextEditingController pulseController;

  @override
  void initState() {
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
            final sys =
                int.tryParse(sysController.text) ?? default_values.defaultZero;
            final dia =
                int.tryParse(diaController.text) ?? default_values.defaultZero;
            final pulse = int.tryParse(pulseController.text) ??
                default_values.defaultZero;
            if (sys > 90 &&
                sys < 170 &&
                dia > 70 &&
                dia < 140 &&
                pulse > 50 &&
                pulse < 160) {
              widget.onDone.call(sys: sys, dia: dia, pulse: pulse);

              Navigator.of(context).pop();
            }
          },
          child: const Icon(Icons.done),
        ),
        body: Column(
          children: [
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
          ],
        ),
      ),
    );
  }
}
