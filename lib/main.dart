import 'package:bluedrip/ProfileScreen.dart';
import 'package:bluedrip/addcase.dart';
import 'package:bluedrip/adduser.dart';
import 'package:bluedrip/emergencycase.dart';
import 'package:bluedrip/hbook.dart';
import 'package:bluedrip/hospital.dart';
import 'package:bluedrip/mrecord.dart';
import 'package:bluedrip/nactive.dart';
import 'package:bluedrip/renewal.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bluedrip/auth/Register.dart';
import 'package:bluedrip/auth/login.dart';
import 'home.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlueDrib',
      home: AnimatedSplashScreen(
        duration: 3000,
        splashIconSize: 400,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Image(
                image: AssetImage("assets/images/icon.png"),
              ),
            ),
            Text("Blue Drip")
          ],
        ),
        nextScreen: login(),
        splashTransition: SplashTransition.fadeTransition,
      ),
      routes: {
        "home": (context) => home(),
        "login": (context) => login(),
        "Register": (context) => Register(),
        "nactive": (context) => nactive(),
        "profile": (context) => ProfileScreen(),
        "hospital": (context) => hospital(),
        "mrecord": (context) => mrecord(),
        "hbook": (context) => hbook(),
        "emergencycase": (context) => emergencycase(),
        "addcase": (context) => addcase(),
        "renewal": (context) => renewal(),
        "adduser": (context) => adduser(),
      },
    );
  }
}
