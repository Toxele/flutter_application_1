import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldPattern extends StatelessWidget {
  const TextFieldPattern({
    super.key,
    required this.onEdit,
    required this.value,
    required this.valueName,
  });

  final String value;
  final String valueName;
  final Function(String value) onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Center(
          child: Text(
            valueName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: value,
          ),
          // todo: сделать в качестве параметров виджета, потому что
          // каждой формочке нужны свои настройки
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          onChanged: onEdit,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
