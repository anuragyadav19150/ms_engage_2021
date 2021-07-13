import 'package:flutter/material.dart';
import 'package:ms_teams_clone/screen/Mysplash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MicroSoft Teams Engage',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MySplashApp());
  }
}
