import 'package:flutter/material.dart';
import 'package:tic_tac/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac',
      theme: ThemeData(
        brightness: Brightness.dark,
        shadowColor: Color(0xFF001456),
        primaryColor: Color(0xFF00061a),
        splashColor: Color(0xFF4169e8),
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
