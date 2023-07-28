import 'package:shared_preferences/shared_preferences.dart';

class SPController 
{
  late final SharedPreferences prefs;
  SPController()
  {
    initPrefs();
  }
  Future<void> initPrefs() async
  { 
    prefs = await SharedPreferences.getInstance();
  }
}
class SPDefault 
{
  String minPulseValue = 'Min Pulse';
}