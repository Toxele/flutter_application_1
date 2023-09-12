import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/model/user_record.dart';

import 'model/user_notification_record.dart';

class UserRecordToDisplay extends ValueNotifier<UserRecord> {
  UserRecordToDisplay(super.value);
}

class UserNotificationRecordToDisplay
    extends ValueNotifier<UserNotificationRecord> {
  UserNotificationRecordToDisplay(
    super.value,
  );
}
