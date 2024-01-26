import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:photo_view/photo_view.dart';

import '../../../shared/constants.dart';
import '../../../utils/size_config.dart';
import '../view_image_screen.dart';

class ImageMsgContainer extends StatelessWidget {
  const ImageMsgContainer(this.isMe, this.img, this.sentAt);

  final bool isMe;
  final DateTime sentAt;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      children: [
        Container(
          width: getProportionateScreenWidth(250),
          height: getProportionateScreenHeight(350),
          padding: const EdgeInsets.all(3),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueGrey[400] : kPrimaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
            onTap: () {
              try {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ViewImageScreen(
                    image: NetworkImage(img),
                    receiveTime: intl.DateFormat.jm().format(sentAt),
                  );
                }));
              } catch (err) {
                print(err);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: PhotoView(
                imageProvider: NetworkImage(img),
              ),
            ),
          ),
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: isMe
                ? const EdgeInsets.only(bottom: 12, right: 24)
                : const EdgeInsets.only(bottom: 12, left: 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              intl.DateFormat.jm().format(sentAt),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
