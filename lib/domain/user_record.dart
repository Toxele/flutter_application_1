import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UserRecord {
  // поля значений, которые вводят пользователь, возможно сюда добавится дата и время
  final int? sys;
  final int? dia;
  final int? pulse;
// DateTime timeOfRecord;
  const UserRecord(this.sys, this.dia, this.pulse);
  factory UserRecord.fromJson(Map<String, dynamic> jsonMap) {
    return UserRecord(
      jsonMap["sys"] as int,
      jsonMap["dia"] as int,
      jsonMap["pulse"] as int,
      //  jsonMap["time"] as DateTime,
    );
  }

  Map toJson() => {"sys": sys, "pulse": pulse, "dia": dia};
}
