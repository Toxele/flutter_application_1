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
    print('12412341241241');
  }
}
class SPDefault 
{
  String minPulseValue = 'Min Pulse';
}