import 'package:flutter/material.dart';
import 'package:flutter_todo/pages/home.dart';
import 'package:flutter_todo/pages/start.dart';


void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.purple,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const Start(),
      '/todo': (context) => const Home()
    },
  ));
}
