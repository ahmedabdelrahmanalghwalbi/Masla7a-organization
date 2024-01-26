import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants.dart';
import '../../../utils/size_config.dart';

//  The default structure for the splash screen
class SplashMainContent extends StatelessWidget {
  const SplashMainContent({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Stack(
          alignment: Alignment.center,
          children: [
            buildVectorsBackgroundCircle(),
            SvgPicture.asset(
              image,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ],
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: getProportionateScreenWidth(16)),
          ),
        ),
      ],
    );
  }

  Widget buildVectorsBackgroundCircle() {
    return Container(
      height: getProportionateScreenHeight(350),
      width: getProportionateScreenWidth(300),
      decoration: const BoxDecoration(
        gradient: kPrimaryGradientColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
