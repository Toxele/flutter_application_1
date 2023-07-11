import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GraphScreenState();
}

class GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Мой график')),
    );
  }
}
