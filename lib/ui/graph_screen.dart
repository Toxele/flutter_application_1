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
      body: const Column(
        children: <Widget>[LineChartSample2(), LineChartSample1()],
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
