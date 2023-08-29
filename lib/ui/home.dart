import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/strings.dart' as strings;
import 'package:flutter_application_1/data/class_instances.dart';
import 'package:flutter_application_1/data/json_loader.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/domain/model/user_record.dart';
import 'package:flutter_application_1/domain/notification_service/notification_service.dart';
import 'package:flutter_application_1/domain/user_data_service.dart';
import 'package:flutter_application_1/domain/user_status_control_service/user_status_controller.dart';
import 'package:flutter_application_1/ui/sceens_to_show_once/set_up_prefs_screen.dart';
import 'package:flutter_application_1/ui/shared/record_info_dialog.dart';
import 'package:provider/provider.dart';

import '../domain/weather/weather.dart';
import 'shared/input_record_dialog.dart';
import 'theme_notifier.dart';

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

class HomeStateSetUpPrefs extends HomeState {
  const HomeStateSetUpPrefs();
  //final SPController sp;
}

class HomeStateNotifier extends ValueNotifier<HomeState> {
  StorageRepository? storage;
  HomeStateNotifier({
    required this.dataService,
    this.storage = null, // todo: внедрить через провайдера
  }) : super(const HomeStateLoading()) {
    load();
  }

  final UserDataService dataService;

  Future<void> addRecord({
    int sys = 120,
    int dia = 80,
    int pulse = 75,
    required Weather weather,
  }) async {
    value = const HomeStateLoading();
    dataService.saveRecord(sys: sys, dia: dia, pulse: pulse, weather: weather);
    await dataService.load();
    value = HomeStateData(dataService.value as List<UserRecord>);
  }

  Future<void> load() async {
    value = switch (dataService.value) {
      RecordsNotifierData(data: final records) => HomeStateData(records),
      RecordsNotifierLoading() => const HomeStateLoading(),
    };
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    // todo: я внедрил это здесь. Но если тебе нужна UserDataService в другом месте,
    //  то здесь ты её можешь получить через `context.watch<UserDataService>()`
    // и тогда ты автоматически избавишься от Proxy
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataService>(
          create: (_) => UserDataService(serviceLoader: const JsonLoader()),
        ),
        ChangeNotifierProxyProvider<UserDataService, HomeStateNotifier>(
          create: (context) => HomeStateNotifier(
            dataService: context.read<UserDataService>(),
          ),
          update: (_, userDataService, __) =>
              HomeStateNotifier(dataService: userDataService),
        ),
      ],
      builder: (context, _) {
        UserStatusNotifier userStatusNotifier = context.watch<UserStatusNotifier>(); //...

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
                final userStatusNotifier = context.read<UserStatusNotifier>();

                showDialog(
                  context: context,
                  builder: (context) {
                    return Provider.value(
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
            builder: (context, recordsNotifier, child) {
              final recordsState = recordsNotifier.value;
              return switch (recordsState) {
                HomeStateData(data: final records) => ListView.separated(
                    separatorBuilder: (context, index) {
                      final time = records[index].timeOfRecord;
                      userStatusNotifier.records = records; // Костыль))

                      if (index == 0 ||
                          records[index - 1].timeOfRecord.day !=
                              records[index].timeOfRecord.day) {
                        return Card(
                          child: Text(
                              '${time.day} ${time.month} ${time.year} года'),
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
                HomeStateSetUpPrefs() => const SetUpSharedPreferencesScreen(),
              };
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
                  padding: const EdgeInsets.only(right: 20),
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
