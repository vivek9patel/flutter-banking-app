import 'package:basic_banking/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home Page",
      home: Home(),
      theme: ThemeData(fontFamily: "Raleway"),
    );
  }
}
