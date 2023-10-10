import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/ui/notifications/notifications_presenter.dart';
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
  final selectedTime =
      ValueNotifier(DateTime.now().add(const Duration(days: 1)));
  final selectedDate =
      ValueNotifier(DateTime.now().add(const Duration(days: 1)));
  bool isActivate = true;

  late final event = widget.event;
  late final isCreateMode = event == null;

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
            isCreateMode ? 'Создание оповещения' : 'Редактирование оповещения',
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notification_add),
            ),
          ],
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
                isActive: true,
              );
            } else {
              // presenter.updateRecord(
              //   text: textController.text,
              //   time: selectedDate.value.copyWith(
              //     hour: selectedTime.value.hour,
              //     minute: selectedTime.value.minute,
              //   ),
              //   isActive: true,
              // );
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                isCreateMode
                    ? DateTime.now().toString()
                    : widget.event!.time.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: const Text('Нажмите, чтобы изменить время'),
              onChanged: (value) {
                setState(() {
                  isActivate = value;
                });
              },
            ),
            // TimeTile(),
            TimeTile(
              dateNotifier: selectedDate,
              timeNotifier: selectedTime,
            ),
          ],
        ),
      ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ValueListenableBuilder(
          valueListenable: timeNotifier,
          builder: (context, value, child) {
            final time = DateFormat('HH:mm').format(value);

            return ActionChip(
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
