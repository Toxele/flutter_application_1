import 'package:flutter/material.dart';
import 'package:flutter_application_1/application/app_const.dart';
import 'package:flutter_application_1/data/storage_repository.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../application/theme_mode_notifier.dart';
import '../dialogues/input_record_dialog.dart';
import '../dialogues/record_info_dialog.dart';
import '../stepper/stepper_screen.dart';
import 'home_presenter.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider2<HypertensionNotifier, StorageRepository,
              HomeStatePresenter>(
            create: (context) => HomeStatePresenter(
              userRecordsNotifier: context.read<HypertensionNotifier>(),
              storage: context.read<StorageRepository>(),
            ),
            update:
                (context, userRecordsNotifier, storage, oldHomeStateNotifier) =>
                    HomeStatePresenter(
              userRecordsNotifier: userRecordsNotifier,
              storage: storage,
            ),
          ),
        ],
        builder: (context, _) {
          final homeStateNotifier = context.read<HomeStatePresenter>();
          final recordsState = homeStateNotifier.value;
          switch (recordsState) {
            case StepperHomeState():
              return Scaffold(
                appBar: AppBar(
                  title: const Text(AppConst.appTitle),
                ),
                body: const _HypertensionBody(),
              );
            default:
              return Scaffold(
                appBar: AppBar(
                  title: const Text(AppConst.appTitle),
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
                  child: const Icon(Icons.add),
                  onPressed: () {
                    final userStatusNotifier =
                        context.read<HypertensionNotifier>();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: userStatusNotifier,
                          child: InputRecordDialog(
                            onDone: homeStateNotifier.addRecord,
                          ),
                        );
                      },
                    );
                  },
                ),
                body: const _HypertensionBody(),
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
                          onTap: () =>
                              Navigator.of(context).pushNamed('/settings'),
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
          }
        });
  }
}

class _HypertensionBody extends StatelessWidget {
  const _HypertensionBody();

  @override
  Widget build(BuildContext context) {
    final homeStateNotifier = context.watch<HomeStatePresenter>();
    final recordsState = homeStateNotifier.value;

    Widget child;
    switch (recordsState) {
      case HomeStateData(data: final records):
        child = ListView.builder(
          // reverse: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: records.length,
          itemBuilder: (BuildContext context, int index) {
            final time = records[index].timeOfRecord;

            if (index == 0 ||
                (records[index - 1].timeOfRecord.day !=
                    records[index].timeOfRecord.day)) {
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat('d MMMM yyyy').format(time),
                      ),
                    ),
                  ),
                  _HypertensionTile(record: records[index]),
                ],
              );
            }
            return _HypertensionTile(record: records[index]);
          },
        );
      case HomeStateLoading():
        child = const Center(
          child: CircularProgressIndicator(),
        );
      case HomeStateError(message: final message):
        child = Center(child: Text(message));
      case StepperHomeState():
        child = const StepperScreen();
      case HomeStateDataEmpty():
        child = const Center(
          child: Text('У вас нет сохранений'),
        );
    }

    return child;
  }
}

class _HypertensionTile extends StatelessWidget {
  final HypertensionModel record;

  const _HypertensionTile({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    // todo использовать DateFormat
    final String currentTime =
        '${record.timeOfRecord.hour}:${record.timeOfRecord.minute > 9 ? record.timeOfRecord.minute : '0${record.timeOfRecord.minute}'}';

    return Dismissible(
      key: ValueKey(record.uuid),
      confirmDismiss: (direction) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Удалить запись?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Нет'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Да'),
            ),
          ],
        ),
      ),
      onDismissed: (direction) =>
          context.read<HomeStatePresenter>().removeRecord(record),
      background: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete),
      ),
      secondaryBackground: const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete),
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (context) {
              return Provider(
                create: (_) => record,
                child: const HypertensionInfo(),
              );
            },
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                Text(
                  record.dia.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
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
                Text(
                  record.pulse.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
