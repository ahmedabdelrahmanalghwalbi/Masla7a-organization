import 'package:flutter/material.dart';
import 'package:maslaha/screens/authenticaton/sign_up_as_worker.dart';
import 'package:maslaha/screens/myProfile/my_profile_screen.dart';

import 'screens/complaint_box/complaint_box.dart';
import 'screens/notifications/notifications.dart';
import 'screens/order/order.dart';
import 'screens/home/filter_screen.dart';
import 'screens/authenticaton/create_new_password_screen.dart';
import 'screens/authenticaton/forget_password_screen.dart';
import 'screens/authenticaton/login_screen.dart';
import 'screens/authenticaton/register_screen_1.dart';
import 'screens/authenticaton/register_screen_2.dart';
import 'screens/authenticaton/verify_your_email_screen.dart';
import 'screens/chat/conversations_screen.dart';
import 'screens/favourites/favourites_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'screens/welcome_screen.dart';

//  All routes will be avilable here

final Map<String, WidgetBuilder> routes = {
  // Initial route
  '/': (context) => LandingScreen(),

  SplashScreen.routeName: (context) => SplashScreen(),
  WelcomeScreen.routeName: (context) => WelcomeScreen(),
  RegisterScreen1.routeName: (context) => RegisterScreen1(),
  RegisterScreen2.routeName: (context) => RegisterScreen2(),
  LoginScreen.routeName: (context) => LoginScreen(),
  ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
  CreateNewPasswordScreen.routeName: (context) => CreateNewPasswordScreen(),
//  VerifyYourEmailScreen.routeName: (context) => VerifyYourEmailScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  FilterScreen.routeName: (context) => FilterScreen(),
  ConversationsScreen.routeName: (context) => ConversationsScreen(),
  FavouritesScreen.routeName: (context) => FavouritesScreen(),
  Notifications.routeName: (context) => Notifications(),
  ComplaintBox.routeName: (context) => ComplaintBox(),
  Order.routeName: (context) => Order(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
};
