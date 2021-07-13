import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ms_teams_clone/channel.dart';
import 'package:ms_teams_clone/screen/IntroScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goMainScreen();
  }

  // 5 seconds later -> onDoneControl
  Future<Timer> goMainScreen() async {
    return new Timer(Duration(seconds: 2), onDoneControl);
  }

  // route to MainScreen
  onDoneControl() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnBoardingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage('assets/msL.png'), height: 200, width: 200),
              Text("MicroSoft Teams Engage",
                  style: new TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      )),
    );
  }
}
