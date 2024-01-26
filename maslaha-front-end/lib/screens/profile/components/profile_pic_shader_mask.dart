import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

class ProfilePicShaderMask extends StatefulWidget {
  final String image;
  ProfilePicShaderMask({required this.image});
  @override
  _ProfilePicShaderMaskState createState() => _ProfilePicShaderMaskState();
}

class _ProfilePicShaderMaskState extends State<ProfilePicShaderMask> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: ShaderMask(
        shaderCallback: (rec) {
          return LinearGradient(
            colors: [
              Colors.black,
              Colors.black38,
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTRB(0, 0, rec.width, rec.height),
          );
        },
        blendMode: BlendMode.dstIn,
        child: Container(
          width: getProportionateScreenWidth(375),
          height: getProportionateScreenHeight(690),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.image), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
