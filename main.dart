import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'Home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Balance Sheet',
        home: Home(),
    );
  }
}


