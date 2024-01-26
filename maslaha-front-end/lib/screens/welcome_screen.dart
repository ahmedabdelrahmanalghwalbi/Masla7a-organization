import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../shared/constants.dart';
import '../utils/size_config.dart';
import 'authenticaton/login_screen.dart';
import 'authenticaton/register_screen_1.dart';
import 'splash_screen/components/splash_main_content.dart';

class WelcomeScreen extends StatefulWidget {
  static String routeName = "/welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _signUpNGuestAnimationController;
  late final AnimationController _signInAnimationController;

  late final Animation<Offset> _signUpOffset;
  late final Animation<Offset> _signInOffset;
  late final Animation<Offset> _guestOffset;

  @override
  void initState() {
    super.initState();
    _signUpNGuestAnimationController =
        AnimationController(vsync: this, duration: kAnimationDuration);
    _signInAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _signUpOffset = Tween(begin: Offset(0.0, 3.5), end: Offset(0.0, 0.0))
        .animate(_signUpNGuestAnimationController);
    _signInOffset = Tween(begin: Offset(0.0, 2.0), end: Offset(0.0, 0.0))
        .animate(_signInAnimationController);
    _guestOffset = Tween(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0))
        .animate(_signUpNGuestAnimationController);

    //  wait the page transition for the buttons animations
    Timer(kAnimationDuration, () {
      _signUpNGuestAnimationController
          .forward()
          .whenComplete(() => _signInAnimationController.forward());
    });
  }

  @override
  void dispose() {
    _signUpNGuestAnimationController.dispose();
    _signInAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              //  Join as guest button
              // Align(
              //   alignment: Alignment.topRight,
              //   child: SlideTransition(
              //     position: _guestOffset,
              //     child: TextButton(
              //       style: TextButton.styleFrom(
              //         padding: EdgeInsets.zero,
              //       ),
              //       onPressed: () {
              //         Navigator.pushReplacementNamed(
              //             context, HomeScreen.routeName);
              //       },
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Text(
              //               'Join as a guest',
              //               style: TextStyle(
              //                 color: Colors.black54,
              //                 fontSize: getProportionateScreenWidth(16),
              //                 letterSpacing: 0.75,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 4.0,
              //             ),
              //             const Icon(
              //               Icons.arrow_forward_ios,
              //               color: Colors.black54,
              //               size: 18.0,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              //  Page view
              Expanded(
                flex: 4,
                child: const SplashMainContent(
                  image: 'assets/images/splash_images/welcome.svg',
                  title: 'Welcome',
                  description:
                      'Welcome to our application, we are glad you made it here and now all you need to is to sign-up to take advantage of our services or if you already one of our beloved users go ahead log-in and enjoy.',
                ),
              ),
              //  Sign in & out buttons
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  margin: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(20),
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      buildEntryButton(
                        label: 'Sign up',
                        onPress: () {
                          Navigator.pushNamed(
                              context, RegisterScreen1.routeName);
                        },
                        offset: _signUpOffset,
                      ),
                      buildEntryButton(
                        label: 'Sign in',
                        onPress: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        offset: _signInOffset,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SlideTransition buildEntryButton(
      {required String label,
      required Function? onPress,
      required Animation<Offset> offset}) {
    return SlideTransition(
      position: offset,
      child: Container(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: kPrimaryColor,
          ),
          onPressed: onPress as void Function(),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(16),
              letterSpacing: 0.75,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
