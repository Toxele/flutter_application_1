import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/data/json_loader.dart';
import 'package:flutter_application_1/domain/model/user_record.dart';
import 'package:flutter_application_1/domain/user_data_service.dart';
import 'package:flutter_application_1/sceens_to_show_once/set_up_prefs_screen.dart';
import 'package:flutter_application_1/ui/shared/record_info_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/weather/weather.dart';
import 'shared/input_record_dialog.dart';

class GHFlutter extends StatefulWidget {
  const GHFlutter({super.key});

  @override
  GHFlutterState createState() => GHFlutterState();
}

class GHFlutterState extends State<GHFlutter> {
  //final _biggerFont = const TextStyle(fontSize: 18.0);
  // ignore: unused_field
  late UserDataService _dataService;
  late List<UserRecord> _dataRecords = [];
  late final SharedPreferences prefs;
  // ignore: avoid_void_async
  void addRecordsToData() async {
    _dataRecords = [];
    _dataRecords.addAll(await _dataService.loadRecords());

    setState(() {});
  }

  void initPrefs() async {
    print('IM HEEEREEE');
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _dataService = UserDataService(const JsonLoader());
    initPrefs();
    // addRecordToData();

    //_dataService.addAll([1, 2, 3, 4, 5]);
  }

  void addRecord(
      {int sys = 120, int dia = 80, int pulse = 75, required Weather weather}) {
    setState(() {
      _dataService.addRecord(
          sys: sys, dia: dia, pulse: pulse, weather: weather);
      addRecordsToData();
      //    print(_dataRecords[0].dia.toString() + 'Im here');
    });
  }

  @override
  Widget build(BuildContext context) {
  /*  if (prefs.getBool('OnceShow') == null) {
      showDialog(
          context: context,
          builder: (context) {
            return SetUpSharedPreferencesScreen();
          });
    }*/ 
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/graph');
            },
            icon: const Icon(Icons.auto_graph_rounded),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return InputRecordDialog(
                  onDone: addRecord,
                );
              },
            );
          },
        ),
        onPressed: () {},
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dataRecords.length,
        itemBuilder: (BuildContext context, int position) {
          return _RowRecords(record: _dataRecords[position]);
        },
      ),
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
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return const RecordInfoDialog();
        },
      ),
      child: Card(
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: const SizedBox(
                width: 10,
                height: 60,
              ),
            ),
            const SizedBox(
              width:
                  10, // тут spacer создаёт лишнее пространство, поэтому на мой взгляд SizedBox вполне удобен здесь
            ),
            Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    'Time', // вместо Time буду подставлять позже конкретное время
                  ),
                ),
                Text(record.sys.toString()),
              ],
            ),
            const Spacer(),
            const Column(
              children: <Widget>[
                Text('SYS'),
                Text('мм.рт.ст'),
              ],
            ),
            const Spacer(),
            Text(record.dia.toString()),
            const Spacer(),
            const Column(
              children: <Widget>[
                Text('DIA'),
                Text('мм.рт.ст'),
              ],
            ),
            const Spacer(),
            Text(record.pulse.toString()),
          ],
        ),
      ),
    );
  }
}
