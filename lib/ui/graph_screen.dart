import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/graphics/hypertension_graphic.dart';
import 'package:flutter_application_1/ui/graphics/pulse_graphic.dart';

class GraphScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GraphScreenState();
}

class GraphScreenState extends State<GraphScreen> {
  late final CartNotifier cartNotifier;

  @override
  void initState() {
    super.initState();
    cartNotifier = CartNotifier();

    cartNotifier.addListener(() {
      print('Произошло обновление состояния');
    });
  }

  @override
  void dispose() {
    super.dispose();
    cartNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мой график')),
      body: Column(
        children: <Widget>[
          _infoTile(value: "График давления"),
          const LineChartSample2(),
          _infoTile(value: "График пульса"),
          const LineChartSample1()
        ],
      ),
      /* ListenableBuilder(
        listenable: cartNotifier,
        builder: (context, child) {
          return ListView(
            children: [...cartNotifier.items.map((e) => Text(e.toString()))],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartNotifier.add(Item());
        },
      ), */
    );
  }
}

class _infoTile extends StatelessWidget {
  String value;
  _infoTile({required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class CartNotifier extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}

class Item {}
