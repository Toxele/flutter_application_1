// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_super_parameters, avoid_unnecessary_containers, sort_child_properties_last, avoid_print, avoid_dynamic_calls

//import 'dart:js_util';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Info.dart';
import 'package:flutter_application_1/strings.dart' as strings;
// ignore: unused_import
import 'package:flutter_application_1/the_morning.dart';
import 'package:flutter_application_1/my_dialog_widget.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'dart:async';
//import 'dart:io';

void main() {
  runApp(GHFlutterApp());
}

class GHFlutterApp extends StatelessWidget {
  const GHFlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: strings.appTitle,
      home: const GHFlutter(),
    );
  }
}

class GHFlutter extends StatefulWidget {
  const GHFlutter({Key? key}) : super(key: key);

  @override
  GHFlutterState createState() => GHFlutterState();
}

class GHFlutterState extends State<GHFlutter> {
  //final _biggerFont = const TextStyle(fontSize: 18.0);
  // ignore: unused_field
  late DataService _dataService;
  late List<UserRecord> _dataRecords = [];
  // ignore: avoid_void_async
  void addRecordToData() async {
    _dataRecords = [];
    _dataRecords.addAll(await _dataService.loadRecords());
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    _dataService = DataService();
    addRecordToData();
  
    //_dataService.addAll([1, 2, 3, 4, 5]);
  }

  void addRecord(int sys, int dia, int pulse) {
    setState(() {
      _dataService.addRecord(sys, dia, pulse);
      addRecordToData();
  //    print(_dataRecords[0].dia.toString() + 'Im here');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.appTitle),
      ),
      floatingActionButton: addRecordDataActionButton(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dataRecords.length,
        itemBuilder: (BuildContext context, int position) {
          return _RowRecords(record: _dataRecords[position]);
        },
      ),
    );
  }

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
    super.key,
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
