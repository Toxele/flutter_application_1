import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/data/class_instances.dart';
import 'package:flutter_application_1/data/json_loader.dart';
import 'package:flutter_application_1/domain/model/user_record.dart';
import 'package:flutter_application_1/domain/user_data_service.dart';
import 'package:flutter_application_1/sceens_to_show_once/set_up_prefs_screen.dart';
import 'package:flutter_application_1/ui/shared/record_info_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/weather/weather.dart';
import 'shared/input_record_dialog.dart';

sealed class HomeState {
  const HomeState();
}

class HomeStateData extends HomeState {
  const HomeStateData(this.data);

  final List<UserRecord> data;
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

class HomeStateError extends HomeState {
  const HomeStateError(this.message);

  final String message;
}

class RecordsNotifier extends ValueNotifier<HomeState> {
  RecordsNotifier({
    required this.dataService,
  }) : super(const HomeStateLoading());

  final UserDataService dataService;

  Future<void> addRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather,
  }) async {
    value = const HomeStateLoading();

    dataService.addRecord(sys: sys, dia: dia, pulse: pulse, weather: weather);

    value = HomeStateData(await dataService.loadRecords());
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordsNotifier>(
      create: (_) => RecordsNotifier(
        dataService: UserDataService(const JsonLoader()),
      ),
      builder: (context, _) => Scaffold(
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
              final recordsNotifier = context.read<RecordsNotifier>();

              showDialog(
                context: context,
                builder: (context) {
                  return InputRecordDialog(
                    onDone: recordsNotifier.addRecord,
                  );
                },
              );
            },
          ),
          onPressed: () {},
        ),
        body: Consumer<RecordsNotifier>(
          builder: (context, recordsNotifier, child) {
            final recordsState = recordsNotifier.value;

            return switch (recordsState) {
              HomeStateData(data: final records) => ListView.separated(
                  separatorBuilder: (context, index) {
                    final time = records[index].timeOfRecord;
                    if (index == 0 ||
                        records[index - 1].timeOfRecord.day !=
                            records[index].timeOfRecord.day) {
                      return Card(
                        child:
                            Text('${time.day} ${time.month} ${time.year} года'),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  padding: const EdgeInsets.all(16),
                  itemCount: records.length,
                  itemBuilder: (BuildContext context, int position) {
                    return _RowRecords(record: records[position]);
                  },
                ),
              HomeStateLoading() =>
                const Center(child: CircularProgressIndicator()),
              HomeStateError(message: final message) =>
                Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }
}

class _RowRecords extends StatelessWidget {
  final UserRecord record;

  const _RowRecords({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    String currentTime =
        '${record.timeOfRecord.hour}:${record.timeOfRecord.minute}';
    // используем тут этот record
    print('build: ${record.dia}');
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => UserRecordToDisplay(record),
            child: const RecordInfoDialog(),
          );
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
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    currentTime, // вместо Time буду подставлять позже конкретное время
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
