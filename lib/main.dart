import 'package:flutter/material.dart';
import 'package:flutter_application_1/strings.dart' as strings;
import 'package:flutter_application_1/ui/graph_screen.dart';

import 'ui/home.dart';

void main() => runApp(const GHFlutterApp());

class GHFlutterApp extends StatelessWidget {
  const GHFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: strings.appTitle,
      initialRoute: '/',
      routes: {
        '/': (context) => const GHFlutter(),
        '/graph': (context) => GraphScreen(),
      },
    );
  }
}
