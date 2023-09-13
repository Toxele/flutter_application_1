import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/events_notification_notifier/event_notification.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';

// todo
class UserRecordToDisplay extends ValueNotifier<HypertensionModel> {
  UserRecordToDisplay(super.value);
}

class UserNotificationRecordToDisplay extends ValueNotifier<EventNotification> {
  UserNotificationRecordToDisplay(
    super.value,
  );
}
