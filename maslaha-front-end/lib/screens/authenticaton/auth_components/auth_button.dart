import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../utils/size_config.dart';

Widget authButton(String title, Function onTap, double top, double left) {
  return Positioned(
      top: getProportionateScreenHeight(top),
      left: getProportionateScreenWidth(left),
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          width: getProportionateScreenWidth(233),
          height: getProportionateScreenHeight(46),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(22),
              ),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: kAuthMainColor),
        ),
      ));
}
