import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/constants.dart';
import '../../../../utils/size_config.dart';
import '../../../welcome_screen.dart';

class SplashGetStartedButton extends StatelessWidget {
  void _moveToWelcomeScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_splash_screens', false);
    Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: kPrimaryColor,
      ),
      onPressed: () {
        _moveToWelcomeScreen(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(16),
                    letterSpacing: 0.75,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
