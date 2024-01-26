import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../../widgets/profile_image_container.dart';

class DrawerHeader extends StatelessWidget {
  final String userName;
  final String location;
  final String profilePicUrl;

  DrawerHeader({
    required this.userName,
    required this.location,
    required this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileImageContainer(
          profileImg: profilePicUrl,
          width: getProportionateScreenWidth(60),
          height: getProportionateScreenHeight(80),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          onTap: () => print('Navigate to profie!'),
        ),
        Wrap(
          direction: Axis.vertical,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(180),
              child: Text(
                userName,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.white60,
                  size: 20.0,
                ),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
