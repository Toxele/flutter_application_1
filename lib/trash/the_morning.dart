import 'package:flutter/material.dart';
import 'my_morning_app_set_todo.dart';
class TheMorningApp extends StatelessWidget {
  const TheMorningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morning App',
      home: TheMorning(),
    );
  }
}

class TheMorning extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TheMorningState();
}

class TheMorningState extends State<TheMorning> {
  late List<MorningRecord> _morning;
  @override
  void initState() {
    super.initState();
    _morning = [MorningRecord(25)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Morning App',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      floatingActionButton: myFloatingActionButton(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _morning.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildRow(position);
        },
      ),
    );
  }
  void addRecord(String text, int priority)
  {

  }
  Widget myFloatingActionButton() {
    return FloatingActionButton(
      child: Container(
        alignment: Alignment.topRight,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MyMorningAppSetTodo(
                      onDone: addRecord,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      onPressed: () => {},
    );
  }

  Widget _buildRow(int i) {
    return const ColoredBox(
      color: Colors.green,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Text1'),
              Text('Text2'),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: l,
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_upward,
              color: Color.fromARGB(255, 202, 245, 241),
            ),
            onPressed: l,
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Color.fromARGB(255, 202, 245, 241),
            ),
            onPressed: l,
          ),
        ],
      ),
    );
  }
}

void l() {}

class MorningRecord {
  int number;
  MorningRecord(this.number);
}
