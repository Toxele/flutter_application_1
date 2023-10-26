import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/ui/notifications/notifications_presenter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show RepeatInterval;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventNotificationInfo extends StatefulWidget {
  const EventNotificationInfo({super.key, required this.event});

  final EventNotification? event;

  @override
  State<EventNotificationInfo> createState() => _EventNotificationInfoState();
}

class _EventNotificationInfoState extends State<EventNotificationInfo> {
  final focusNode = FocusNode();
  final textController = TextEditingController();
  late final ValueNotifier<DateTime> selectedTime;
  late final ValueNotifier<DateTime> selectedDate;
  late final ValueNotifier<RepeatInterval?> repeatInterval;
  bool isActivate = true;

  late final EventNotification? event = widget.event;
  late final isCreateMode = event == null;

  @override
  void initState() {
    final time = event != null
        ? event!.time
        : DateTime.now().add(const Duration(days: 1, hours: 1));

    repeatInterval = ValueNotifier(null);
    selectedTime = ValueNotifier(time);
    selectedDate = ValueNotifier(time);
    super.initState();
  }

  @override
  void dispose() {
    selectedTime.dispose();
    selectedDate.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isCreateMode
                ? 'Создание уведомление'
                : 'Редактирование уведомления',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'notification_action',
          child: const Icon(Icons.save),
          onPressed: () async {
            final presenter = context.read<NotificationsScreenPresenter>();

            if (isCreateMode) {
              await presenter.addRecord(
                text: textController.text,
                time: selectedDate.value.copyWith(
                  hour: selectedTime.value.hour,
                  minute: selectedTime.value.minute,
                ),
                repeatInterval: repeatInterval.value,
                isActive: true,
              );
            } else {
              await presenter.updateRecord(
                text: textController.text,
                time: selectedDate.value.copyWith(
                  hour: selectedTime.value.hour,
                  minute: selectedTime.value.minute,
                ),
                repeatInterval: repeatInterval.value,
                isActive: true,
                oldRecord: event!,
              );
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        body: Column(
          children: [
            ListTile(
              title: const Text('Текст уведомления:'),
              subtitle: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: isCreateMode
                    ? textController
                    : (textController..text = widget.event!.text),
                focusNode: isCreateMode ? (focusNode..requestFocus()) : null,
              ),
            ),
            const Divider(),
            SwitchListTile(
              value: isActivate,
              title: Text(
                'Уведомление ${isActivate ? '' : 'не '}активировано',
              ),
              subtitle:
                  const Text('Мы уведомим Вас согласно текущим настройкам'),
              onChanged: (value) {
                setState(() {
                  isActivate = value;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: const Center(
                child: Text('Нажмите ниже для настройки времени'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TimeTile(
                  dateNotifier: selectedDate,
                  timeNotifier: selectedTime,
                ),
              ),
            ),
            const Divider(),
            PeriodicallyWidget(repeatInterval: repeatInterval),
          ],
        ),
      ),
    );
  }
}

class PeriodicallyWidget extends StatelessWidget {
  const PeriodicallyWidget({
    super.key,
    required this.repeatInterval,
  });

  final ValueNotifier<RepeatInterval?> repeatInterval;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: repeatInterval,
      builder: (context, interval, _) {
        return Column(
          children: [
            SwitchListTile(
              title: const Text('Периодичность уведомлений'),
              value: interval != null,
              onChanged: (value) => repeatInterval.value = RepeatInterval.daily,
            ),
            if (interval != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu<RepeatInterval>(
                  width: MediaQuery.sizeOf(context).width - 16.0,
                  enableSearch: false,
                  initialSelection: interval,
                  label: const Text('Периодичность'),
                  dropdownMenuEntries: [
                    for (final interval in RepeatInterval.values)
                      DropdownMenuEntry<RepeatInterval>(
                        label: interval.label,
                        value: interval,
                      ),
                  ],
                  onSelected: (value) => repeatInterval.value = value,
                ),
              ),
          ],
        );
      },
    );
  }
}

class TimeTile extends StatelessWidget {
  const TimeTile({
    super.key,
    required this.timeNotifier,
    required this.dateNotifier,
  });

  final ValueNotifier<DateTime> timeNotifier;
  final ValueNotifier<DateTime> dateNotifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ValueListenableBuilder(
          valueListenable: timeNotifier,
          builder: (context, value, child) {
            final time = DateFormat('HH:mm').format(value);

            return ActionChip(
              elevation: 6.0,
              shadowColor: theme.primaryColor,
              onPressed: () async {
                final time = timeNotifier.value;

                // todo задать ограничение, что выбранное время не может быть меньше текущего
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: time.hour, minute: time.minute),
                );

                if (selectedTime == null) return;

                timeNotifier.value = time.copyWith(
                  hour: selectedTime.hour,
                  minute: selectedTime.minute,
                );
              },
              label: Text(time), // use value
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            final date = DateFormat('d MMMM yyyy').format(value);

            return ActionChip(
              elevation: 6.0,
              shadowColor: theme.primaryColor,
              onPressed: () async {
                final date = dateNotifier.value;

                final selected = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: date.add(const Duration(days: 365)),
                  initialDate: date,
                );

                if (selected == null) return;

                dateNotifier.value = selected;
              },
              label: Text(date), // use value
            );
          },
        ),
      ],
    );
  }
}
