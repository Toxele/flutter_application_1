import 'package:flutter/material.dart';

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
            widget.onDone.call(
              int.parse(sysController.text),
              int.parse(diaController.text),
              int.parse(pulseController.text),
            );
            Navigator.of(context).pop();
          },
          child: Icon(Icons.done),
        ),
        body: Column(children: [
          TextField(
            controller: sysController,
          ),
          TextField(
            controller: diaController,
          ),
          TextField(
            controller: pulseController,
          ),
        ]),
      ),
    );
  }
}
