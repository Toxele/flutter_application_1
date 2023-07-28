import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart' as defaultValues;
import 'package:shared_preferences/shared_preferences.dart';
class UserStatusController {
  late final SharedPreferences prefs;
  UserStatusController()
  {
    initPrefs();
  }
  Future<void> initPrefs() async
  {
      prefs = await SharedPreferences.getInstance();
  }
  Future<bool> acceptRecord(int sys, int dia, int pulse) async {
    prefs.setInt('Dia Min', 70); // это временно
    prefs.setInt('Dia Max', 140);
    prefs.setInt('Sys Min', 90);
    prefs.setInt('Sys Max', 170);
    prefs.setInt('Pulse Min', 60);
    prefs.setInt('Pulse Max', 130);
    int normalSysMin = prefs.getInt('Sys Min') ?? defaultValues.defaultZero;
    int normalSysMax = prefs.getInt('Sys Max') ?? defaultValues.defaultZero;
    int normalDiaMin = prefs.getInt('Dia Min') ?? defaultValues.defaultZero;
    int normalDiaMax = prefs.getInt('Dia Max') ?? defaultValues.defaultZero;
    int normalPulseMin = prefs.getInt('Pulse Min') ?? defaultValues.defaultZero;
    int normalPulseMax = prefs.getInt('Pulse Max') ?? defaultValues.defaultZero;
    return normalSysMin < sys && sys < normalSysMax && normalDiaMin < dia && dia < normalDiaMax && normalPulseMin < pulse && pulse < normalPulseMax;
  }
  Color checkColor()
  {

    return Colors.red;
  }
}
