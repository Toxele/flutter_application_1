import 'package:loggy/loggy.dart';

mixin CustomLog implements LoggyType {
  @override
  Loggy<CustomLog> get loggy => l;

  Loggy<CustomLog> get l => Loggy<CustomLog>('Log[$runtimeType]');
}
