import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';
import './../dash/dash.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: Dash(),
        title: Text(
          'Welcome to EasyLabs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('asset/splash_girl.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.red);
  }
}
