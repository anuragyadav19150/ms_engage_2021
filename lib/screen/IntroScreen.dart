import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ms_teams_clone/channel.dart';
import 'package:ms_teams_clone/extra/button.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Video call with Loved ones ',
              body: 'Free Video call with wonderful experience',
              image: buildImage('assets/1.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Video call wih Group',
              body: 'At max Four people can join together',
              image: buildImage('assets/2.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Wanna Chat',
              body: 'Chat with your friends Like Never Before',
              image: buildImage('assets/3.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Enter your User ID and room code',
              body: 'Start your smooth experience',
              footer: ButtonWidget(
                text: "Let's Go",
                onClicked: () => goToHome(context),
              ),
              image: buildImage('assets/4.jpg'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: Text('Skip'),
          onSkip: () => goToHome(context),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          // globalBackgroundColor: Theme.of(context).primaryColor,
          skipFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => channel()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
