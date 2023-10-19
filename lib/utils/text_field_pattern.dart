import 'package:flutter/material.dart';

class TextFieldPattern extends StatelessWidget {
  const TextFieldPattern({
    super.key,
    required this.onEdit,
    required this.value,
    required this.valueName,
    this.inputType = TextInputType.number,
  });

  final String value;
  final String valueName;
  final TextInputType inputType;
  final Function(String value) onEdit;

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    Color color = style.secondaryHeaderColor;
    return Column(
      children: [ 
        const SizedBox(height: 25),
        Center(
          child: Text(
            valueName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 5,),
        TextField(
          decoration: InputDecoration(
            hintText: value,
            filled: true,
            fillColor: color,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // todo: сделать в качестве параметров виджета, потому что
          // каждой формочке нужны свои настройки
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          keyboardType: inputType,
          onChanged: onEdit,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
