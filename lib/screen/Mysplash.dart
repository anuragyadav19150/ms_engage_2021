import 'package:flutter/material.dart';
import 'package:ms_teams_clone/channel.dart';
import 'package:ms_teams_clone/screen/IntroScreen.dart';
import 'package:ms_teams_clone/screen/splash.dart';

class MySplashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MicroSoft Team Engage',
      debugShowCheckedModeBanner: false,
      theme:
          new ThemeData(primaryColor: Colors.blueAccent, fontFamily: 'Poppins'),
      home: SplashScreen(),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/main': (context) => OnBoardingPage(),
      },
    );
  }
}
