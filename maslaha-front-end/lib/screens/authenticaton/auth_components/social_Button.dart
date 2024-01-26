import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/size_config.dart';

Widget socialButton(IconData icon, Function onTap, Color color) {
  return GestureDetector(
    onTap: onTap as void Function()?,
    child: Container(
      width: getProportionateScreenHeight(48),
      height: getProportionateScreenHeight(48),
      child: Center(
          child: FaIcon(
        icon,
        color: Colors.white,
      )),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(100)),
    ),
  );
}
