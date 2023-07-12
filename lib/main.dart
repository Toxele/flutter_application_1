// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_super_parameters, avoid_unnecessary_containers, sort_child_properties_last, avoid_print, avoid_dynamic_calls

//import 'dart:js_util';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/strings.dart' as strings;
import 'package:flutter_application_1/ui/graph_screen.dart';

// ignore: always_use_package_imports
import 'ui/home.dart';

void main() {
  runApp(GHFlutterApp());
}

class GHFlutterApp extends StatelessWidget {
  const GHFlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: strings.appTitle,
      initialRoute: '/',
      routes: {
        '/': (context) => GHFlutter(),
        '/graph': (context) => GraphScreen(),
      },
    );
  }
}
