import 'package:flutter/material.dart';

import '../shared/constants.dart';

class ProfileImageContainer extends StatelessWidget {
  final String profileImg;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final Function()? onTap;

  const ProfileImageContainer({
    required this.profileImg,
    this.width,
    this.height,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return GestureDetector(
        child: Container(
          width: width ?? cons.constrainWidth(60),
          height: height ?? cons.constrainHeight(60),
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: profileImg.isEmpty
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: const CircularProgressIndicator(color: kPrimaryColor),
                ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    profileImg,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        onTap: onTap ?? () {},
      );
    });
  }
}
