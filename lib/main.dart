import 'package:flutter/material.dart';
//import 'package:whatisinfridgedatabase/Home.dart';
import 'curved_nav_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BottomNavBar(),
        title:'My Flutter App');
  }
}
