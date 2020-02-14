import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:first_time_screen/first_time_screen.dart';
import './screens/dash/dash.dart';
import './screens/intro/intro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Labs - Laboratory Dashboard',
      theme: ThemeData(
        primaryColorDark: Colors.green,
        primarySwatch: Colors.blue,
      ),
//      darkTheme: ThemeData.dark(),
//      themeMode: ThemeMode.dark,
      home: FirstTimeScreen(
        loadingScreen: Intro(),
        introScreen: MaterialPageRoute(builder: (context) => Intro()),
        landingScreen: MaterialPageRoute(builder: (context) => Dash()),
      ),
    );
  }
}
