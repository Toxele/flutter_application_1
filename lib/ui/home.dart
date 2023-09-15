import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/domain/notifiers/abstract/records_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/weather_notifier/weather.dart';
import 'package:flutter_application_1/domain/services/notification_service/notification_service.dart';
import 'package:flutter_application_1/ui/class_instances.dart';
import 'package:flutter_application_1/ui/sceens_to_show_once/set_up_prefs_screen.dart';
import 'package:flutter_application_1/ui/shared/record_info_dialog.dart';
import 'package:provider/provider.dart';

import 'shared/input_record_dialog.dart';
import 'theme_notifier.dart';

sealed class HomeState {
  const HomeState();
}

class HomeStateData extends HomeState {
  const HomeStateData(this.data);

  final List<HypertensionModel> data;
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

class HomeStateError extends HomeState {
  const HomeStateError(this.message);

  final String message;
}

class HomeStateDataEmpty extends HomeState {
  const HomeStateDataEmpty();
}

class StepperHomeState extends HomeState {
  const StepperHomeState();
}

class HomeStateNotifier extends ValueNotifier<HomeState> {
  HomeStateNotifier({
    required this.userRecordsNotifier,
    required this.storage,
  }) : super(const HomeStateLoading()) {
    load();
  }

  final HypertensionNotifier userRecordsNotifier;
  final StorageRepository storage;

  Future<void> addRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather,
  }) async {
    value = const HomeStateLoading();
    userRecordsNotifier.saveRecord(
      sys: sys,
      dia: dia,
      pulse: pulse,
      weather: weather,
    );
  }

  Future<void> load() async {
    final isTimeToStepper =
        storage.storage.getBool(StorageStore.isTimeToStepperKey) ??
            StorageStore.isTimeToStepperDefaultValue;
    if (isTimeToStepper) {
      value = const StepperHomeState();
      return;
    }

    value = switch (userRecordsNotifier.value) {
      RecordsNotifierData(data: final records) => HomeStateData(records),
      RecordsNotifierLoading() => const HomeStateLoading(),
      RecordsNotifierEmpty() => const HomeStateDataEmpty(),
    };
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider2<HypertensionNotifier, StorageRepository,
            HomeStateNotifier>(
          create: (context) => HomeStateNotifier(
            userRecordsNotifier: context.read<HypertensionNotifier>(),
            storage: context.read<StorageRepository>(),
          ),
          update:
              (context, userRecordsNotifier, storage, oldHomeStateNotifier) =>
                  HomeStateNotifier(
            userRecordsNotifier: userRecordsNotifier,
            storage: storage,
          ),
        ),
      ],
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(strings.appTitle),
            actions: [
              IconButton(
                onPressed: () {
                  context
                      .read<NotificationService>()
                      .showNotificationWithActions();
                },
                icon: const Icon(Icons.notification_add),
              ),
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
                final recordsNotifier = context.read<HomeStateNotifier>();
                final userStatusNotifier = context.read<HypertensionNotifier>();

                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: userStatusNotifier,
                      child: InputRecordDialog(
                        onDone: recordsNotifier.addRecord,
                      ),
                    );
                  },
                );
              },
            ),
            onPressed: () {},
          ),
          body: Consumer<HomeStateNotifier>(
            builder: (context, homeStateNotifier, child) {
              final recordsState = homeStateNotifier.value;
              Widget child;
              switch (recordsState) {
                case HomeStateData(data: final records):
                  child = ListView.separated(
                    separatorBuilder: (context, index) {
                      final time = records[index].timeOfRecord;

                      if (index == 0 ||
                          records[index - 1].timeOfRecord.day !=
                              records[index].timeOfRecord.day) {
                        return Card(
                          child: Text(
                            '${time.day} ${time.month} ${time.year} года',
                          ),
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
                  );
                case HomeStateLoading():

                  child = const Center(
                    child: CircularProgressIndicator(),
                  );
                case HomeStateError(message: final message):
                  child = Center(child: Text(message));
                case StepperHomeState():
                  child = const SetUpSharedPreferencesScreen();
                case HomeStateDataEmpty():
                  child = const Center(
                    child: Text('У вас нет сохранений'),
                  );
              }
              return child;
            },
          ),
          drawer: SafeArea(
            child: Drawer(
              child: ListView(
                children: [
                  const FlutterLogo(
                    size: 50,
                    style: FlutterLogoStyle.horizontal,
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Настройки'),
                    onTap: () => Navigator.of(context).pushNamed('/settings'),
                  ),
                  ListTile(
                    title: const Text('Уведомления'),
                    onTap: () =>
                        Navigator.of(context).pushNamed('/notifications'),
                  ),
                  Builder(
                    builder: (context) {
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;

                      return SwitchListTile(
                        title: const Text('Тема'),
                        subtitle: Text(isDark ? 'Тёмная' : 'Светлая'),
                        value: isDark,
                        onChanged: (value) {
                          context.read<ThemeModeNotifier>().setTheme(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RowRecords extends StatelessWidget {
  final HypertensionModel record;

  const _RowRecords({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    String currentTime =
        '${record.timeOfRecord.hour}:${record.timeOfRecord.minute > 9 ? record.timeOfRecord.minute : '0${record.timeOfRecord.minute}'}';
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
            const SizedBox(
              width: 4,
            ),
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
              width: 7,
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    bottom: 3,
                  ),
                  child: Text(
                    currentTime,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  record.sys.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              width: 7,
            ),
            const Column(
              children: <Widget>[
                Text(
                  'SYS',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  'мм.рт.ст',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(
              width: 50,
            ),
            Text(record.dia.toString(), style: const TextStyle(fontSize: 20)),
            const SizedBox(
              width: 10,
            ),
            const Column(
              children: <Widget>[
                Text(
                  'DIA',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  'мм.рт.ст',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            Text(record.pulse.toString(), style: const TextStyle(fontSize: 20)),
            const SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
