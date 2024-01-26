import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maslaha/screens/authenticaton/register_screen_1.dart';
import 'package:maslaha/screens/authenticaton/sign_up_as_worker.dart';
import 'package:maslaha/screens/myProfile/my_profile_screen.dart';
import 'package:maslaha/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../complaint_box/complaint_box.dart';
import '../../notifications/notifications.dart';
import '../../order/order.dart';
import '../../../utils/size_config.dart';

import '../../chat/conversations_screen.dart';
import '../../../shared/constants.dart';
import '../../favourites/favourites_screen.dart';
import '../../home/home_screen.dart';

class NavigationTabs extends StatefulWidget {
  @override
  _NavigationTabsState createState() => _NavigationTabsState();
}

class _NavigationTabsState extends State<NavigationTabs> {
  int _activeTab = 0;
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tabs = [
      {
        "label": "Home",
        "icon": 'assets/icons/drawer_icons/home.svg',
        "routeName": HomeScreen.routeName,
      },
      {
        "label": "Profile",
        "icon": 'assets/icons/drawer_icons/avatar.svg',
        'routeName': MyProfileScreen.routeName,
      },
      {
        "label": "Chat",
        "icon": 'assets/icons/drawer_icons/chat.svg',
        "routeName": ConversationsScreen.routeName,
      },
      {
        "label": "Notifications",
        "icon": 'assets/icons/drawer_icons/notifications.svg',
        "routeName": Notifications.routeName,
      },
      {
        "label": "Provide a service",
        "icon": 'assets/icons/drawer_icons/pencil.svg',
        "routeName": RegisterScreen1.routeName,
      },
      {
        "label": "Favourites",
        "icon": 'assets/icons/drawer_icons/heart.svg',
        "routeName": FavouritesScreen.routeName,
      },
      {
        "label": "Orders",
        "icon": 'assets/icons/drawer_icons/credit-card.svg',
        "routeName": Order.routeName,
      },
      {
        "label": "Make complaints",
        "icon": 'assets/icons/drawer_icons/dislike.svg',
        "routeName": ComplaintBox.routeName,
      },
      {
        "label": "Log out",
        "icon": 'assets/icons/drawer_icons/logout.svg',
        "routeName": WelcomeScreen.routeName,
      },
    ];

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemExtent: 45,
      itemCount: tabs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            setState(() {
              _activeTab = index;
            });

            var route = tabs[_activeTab]['routeName'] as String;

            if (tabs[_activeTab]['label'] == 'Log out') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('token', '');
              prefs.setString('id', '');
              prefs.setBool('isAuth', false);
            }

            if (route.startsWith('/')) {
              Timer(Duration(seconds: 1), () {
                Navigator.pushNamed(context, route);
                setState(() {
                  _activeTab = 0;
                });
              });
            }
          },
          child: AnimatedContainer(
            duration: kAnimationDuration,
            curve: Curves.easeInOutSine,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: _activeTab == index
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                          Colors.white24.withOpacity(0.15),
                          Colors.white10.withOpacity(0.0)
                        ])
                  : null,
            ),
            child: Row(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: kAnimationDuration,
                      alignment: Alignment.center,
                      curve: Curves.easeInOutSine,
                      margin: const EdgeInsets.only(right: 10.0),
                      width: 4.0,
                      height:
                          _activeTab == index ? constraints.biggest.height : 0,
                      decoration: BoxDecoration(
                        color: _activeTab == index
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    );
                  },
                ),
                SvgPicture.asset(
                  tabs[index]['icon'] as String,
                  color: _activeTab == index ? Colors.white : Colors.white54,
                  fit: BoxFit.cover,
                  height: getProportionateScreenHeight(26),
                  width: getProportionateScreenWidth(26),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    tabs[index]['label'] as String,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color:
                          _activeTab == index ? Colors.white : Colors.white54,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
