import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/size_config.dart';

class SocialButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: getProportionateScreenHeight(393),
      left: getProportionateScreenWidth(264),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              width: getProportionateScreenWidth(30),
              height: getProportionateScreenWidth(30),
              child: Center(
                child: FaIcon(FontAwesomeIcons.facebookF,
                    color: Colors.white, size: getProportionateScreenWidth(15)),
              ),
              decoration: BoxDecoration(
                  color: Color(0xff146EE5),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: getProportionateScreenWidth(2),
                right: getProportionateScreenWidth(2)),
            child: GestureDetector(
              child: Container(
                width: getProportionateScreenWidth(30),
                height: getProportionateScreenWidth(30),
                child: Center(
                  child: FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.white,
                      size: getProportionateScreenWidth(15)),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xffEA15E1),
                      Color(0xffFD8418),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              width: getProportionateScreenWidth(30),
              height: getProportionateScreenWidth(30),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.twitter,
                  color: Colors.white,
                  size: getProportionateScreenWidth(15),
                ),
              ),
              decoration: BoxDecoration(
                  color: Color(0xff11BDE9),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
