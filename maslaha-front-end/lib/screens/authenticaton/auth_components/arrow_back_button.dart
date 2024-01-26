import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

Widget arrowBackButton(BuildContext context) {
  return Positioned(
    top: getProportionateScreenHeight(43),
    left: getProportionateScreenWidth(15),
    child: IconButton(
      icon: Icon(Icons.arrow_back_ios,
          color: Colors.white, size: getProportionateScreenHeight(30)),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
