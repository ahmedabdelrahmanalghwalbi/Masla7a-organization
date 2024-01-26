import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/splash_screen/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../shared/constants.dart';

//  Landing screen of the App logo and name to be shown,
//  while the necessary processes are being loaded in the background

class LandingScreen extends StatefulWidget {
  static String routeName = "/landing";

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late bool _showSplashScreen;
  late bool _isAuthorized;

  final List<String> _nextScreenSvgsPath = const [
    'assets/images/splash_images/find_your_service.svg',
    'assets/images/splash_images/full_time_support.svg',
    'assets/images/splash_images/virtual_workshops.svg',
    'assets/images/splash_images/online_payment.svg',
    'assets/images/splash_images/welcome.svg',
  ];

  List<Future> _cacheNextScreenSvgs(List<String> svgPath) {
    return List.generate(_nextScreenSvgsPath.length, (index) async {
      await precachePicture(
          ExactAssetPicture(SvgPicture.svgStringDecoder, svgPath[index]), null);
    });
  }

  Future _prepareNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showSplashScreen = prefs.getBool('show_splash_screens') ?? true;
      _isAuthorized = prefs.getBool('isAuth') ?? false;
    });
    return _showSplashScreen
        ? Future.wait(_cacheNextScreenSvgs(_nextScreenSvgsPath))
        : Future.wait([_cacheNextScreenSvgs(_nextScreenSvgsPath).last]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prepareNextScreen(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _showSplashScreen
              ? SplashScreen()
              : _isAuthorized
                  ? HomeScreen()
                  : WelcomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/partnership_app_logo.svg',
                    color: kPrimaryColor,
                  ),
                  //  App name
                  const Text(
                    "Masla7a",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
