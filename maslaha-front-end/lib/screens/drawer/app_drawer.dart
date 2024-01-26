import 'package:flutter/material.dart';
import 'package:reside_menu/reside_menu.dart';

import '../../utils/size_config.dart';
import '../../widgets/profile_image_container.dart';
import 'components/drawer_footer.dart';
import 'components/drawer_header.dart' as header;
import 'components/navigation_tabs.dart';

class AppDrawer extends StatelessWidget {
  final Widget home;
  final Widget? fab;
  final FloatingActionButtonLocation? fabLocation;
  final String userName;
  final String location;
  final String profilePicUrl;

  AppDrawer(
      {required this.home,
      this.fab,
      this.fabLocation,
      required this.userName,
      required this.location,
      required this.profilePicUrl});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ResideMenu.scaffold(
      appBarTitle: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userName.isEmpty ? 'Loading...' : userName,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16.0,
              color: Colors.black,
            ),
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.black,
                size: 20.0,
              ),
              Text(
                location.isEmpty ? 'Loading...' : location,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
      appBarTrailing: ProfileImageContainer(
        width: getProportionateScreenWidth(55),
        profileImg: profilePicUrl,
        onTap: () => print('Navigate to profie!'),
      ),
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF107AD6), Color(0xFF083D6B)],
        ),
      ),
      leftScaffold: MenuScaffold(
        header: header.DrawerHeader(
          userName: userName,
          location: location,
          profilePicUrl: profilePicUrl,
        ),
        children: NavigationTabs(),
        // footer: DrawerFooter(),
      ),
      enableFade: false,
      child: home,
      fab: fab,
      fabLocation: fabLocation,
    );
  }
}
