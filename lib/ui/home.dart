import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/json_loader.dart';
import 'package:flutter_application_1/domain/user_data_service.dart';
import 'package:flutter_application_1/domain/user_record.dart';

import 'package:flutter_application_1/strings.dart' as strings;

import 'shared/my_dialog_widget.dart';

class GHFlutter extends StatefulWidget {
  const GHFlutter({Key? key}) : super(key: key);

  @override
  GHFlutterState createState() => GHFlutterState();
}

class GHFlutterState extends State<GHFlutter> {
  //final _biggerFont = const TextStyle(fontSize: 18.0);
  // ignore: unused_field
  late UserDataService _dataService;
  late List<UserRecord> _dataRecords = [];
  // ignore: avoid_void_async
  void addRecordToData() async {
    _dataRecords = [];
    _dataRecords.addAll(await _dataService.loadRecords());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _dataService = UserDataService(JsonLoader());
    addRecordToData();

    //_dataService.addAll([1, 2, 3, 4, 5]);
  }

  void addRecord({int sys = 120, int dia = 80, int pulse = 75}) {
    setState(() {
      _dataService.addRecord(sys: sys, dia: dia, pulse: pulse);
      addRecordToData();
      //    print(_dataRecords[0].dia.toString() + 'Im here');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/graph');
            },
            icon: Icon(Icons.auto_graph_rounded),
          )
        ],
      ),
      floatingActionButton: addRecordDataActionButton(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dataRecords.length,
        itemBuilder: (BuildContext context, int position) {
          return _RowRecords(record: _dataRecords[position]);
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //      icon: Icon(Icons.home),
      //    ),
      //    BottomNavigationBarItem(
      //      icon: Icon(Icons.account_box_sharp),
      //    ),
      //  ],
      //  )

      //   Row(
      //   children: <Widget>[
      //      Navigator(
      //    pages: [
      //      MaterialPage(
      //        key: const ValueKey('graph_screen'),
      //        child: GraphScreen(
      //    onItemTapped: _handleItemTapped,
      //  onRouteTapped: _handleRouteTapped,
      //       ),
      //     ),

      //   ],
      //   onPopPage: (route, result) => route.didPop(result),
      // ),
      //    ],
      // ),
    );
  }

  // todo: так не надо, перемести код в build
  Widget addRecordDataActionButton() {
    return FloatingActionButton(
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return MyDialog(
                onDone: addRecord,
              );
            },
          );
        },
      ),
      onPressed: () {},
    );
  }
}

class _RowRecords extends StatelessWidget {
  const _RowRecords({
    required this.record,
  });

  final UserRecord record;

  @override
  Widget build(BuildContext context) {
    // используем тут этот record
    return Card(
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: SizedBox(
              width: 10,
              height: 60,
            ),
          ),
          SizedBox(
            width:
                10, // тут spacer создаёт лишнее пространство, поэтому на мой взгляд SizedBox вполне удобен здесь
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  'Time', // вместо Time буду подставлять позже конкретное время
                ),
              ),
              Text(record.sys.toString()),
            ],
          ),
          Spacer(),
          Column(
            children: <Widget>[
              Text('SYS'),
              Text('мм.рт.ст'),
            ],
          ),
          Spacer(),
          Text(record.dia.toString()),
          Spacer(),
          Column(
            children: <Widget>[
              Text('DIA'),
              Text('мм.рт.ст'),
            ],
          ),
          Spacer(),
          Text(record.pulse.toString()),
        ],
      ),
    );
  }
}
