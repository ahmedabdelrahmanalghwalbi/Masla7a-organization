import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class MyAboutMe extends StatefulWidget {
  String text;
  MyAboutMe({required this.text});
  @override
  _MyAboutMeState createState() => _MyAboutMeState();
}

class _MyAboutMeState extends State<MyAboutMe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenHeight(10)),
//      padding: EdgeInsets.all(20),
      width: getProportionateScreenWidth(350),
      height: getProportionateScreenHeight(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: getProportionateScreenHeight(5)),
            child: Text(
              'About Me',
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: .8),
            ),
          ),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(10),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
