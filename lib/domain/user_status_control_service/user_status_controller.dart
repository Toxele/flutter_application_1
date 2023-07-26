import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/default_values.dart' as defaultValues;
import 'package:shared_preferences/shared_preferences.dart';
class UserStatusController {
  Future<bool> acceptRecord(int sys, int dia, int pulse) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('Dia Min', 70); // это временно
    prefs.setInt('Dia Max', 140);
    prefs.setInt('Sys Min', 90);
    prefs.setInt('Sys Max', 170);
    prefs.setInt('Pulse Min', 60);
    prefs.setInt('Pulse Max', 130);
    int normalSysMin = await prefs.getInt('Sys Min') ?? defaultValues.defaultZero;
    int normalSysMax = await prefs.getInt('Sys Max') ?? defaultValues.defaultZero;
    int normalDiaMin = await prefs.getInt('Dia Min') ?? defaultValues.defaultZero;
    int normalDiaMax = await prefs.getInt('Dia Max') ?? defaultValues.defaultZero;
    int normalPulseMin = await prefs.getInt('Pulse Min') ?? defaultValues.defaultZero;
    int normalPulseMax = await prefs.getInt('Pulse Max') ?? defaultValues.defaultZero;
    return normalSysMin < sys && sys < normalSysMax && normalDiaMin < dia && dia < normalDiaMax && normalPulseMin < pulse && pulse < normalPulseMax;
  }
  Color checkColor()
  {

    return Colors.red;
  }
}
