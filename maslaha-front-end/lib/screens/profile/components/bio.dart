import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/size_config.dart';

class BioInformation extends StatelessWidget {
  late String title;
  late IconData fIcon;
  late Color color;
  late double iconSize;
  late double fontSize;
  BioInformation(
      {required this.fontSize,
      required this.color,
      required this.title,
      required this.fIcon,
      required this.iconSize});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          fIcon,
          color: color,
          size: iconSize,
        ),
        Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
          child: Text(
            '${title}',
            style: TextStyle(
                fontSize: getProportionateScreenWidth(fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
