import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class StatusBadge extends StatelessWidget {
  final Map<String, Object> status;
  final double size;
  final double borderSize;

  late final Widget child;
  late final double? left;
  late final double? top;
  late final double? right;
  late final double? bottom;

  final bool withText;
  final Color textColor;
  final double textSize;

  late final bool _isOverlayed;

  StatusBadge({
    required this.status,
    this.size = 6,
    this.borderSize = 0,
    this.withText = false,
    this.textColor = Colors.white,
    this.textSize = 14,
  }) {
    this._isOverlayed = false;

    this.child = SizedBox.shrink();
    this.left = null;
    this.top = null;
    this.right = null;
    this.bottom = null;
  }

  StatusBadge.overlayed({
    required this.child,
    required this.status,
    this.size = 6,
    this.borderSize = 0,
    this.withText = false,
    this.textColor = Colors.white,
    this.textSize = 14,
    this.left,
    this.top,
    this.right,
    this.bottom,
  }) {
    this._isOverlayed = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_isOverlayed)
      return Stack(
        children: [
          child,
          Positioned(
            left: left,
            top: top,
            right: right,
            bottom: bottom,
            child: buildBadge(
              badgeSize: size,
              badgeBorder: borderSize,
              badgeColor: status['color'] as Color,
            ),
          ),
        ],
      );
    else
      return buildBadge(
        badgeSize: size,
        badgeBorder: borderSize,
        badgeColor: status['color'] as Color,
      );
  }

  Widget buildBadge(
      {required double badgeSize,
      required double badgeBorder,
      required Color badgeColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: badgeBorder,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: badgeColor,
            radius: badgeSize,
          ),
        ),
        if (withText)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              status['text'] as String,
              style: TextStyle(
                color: textColor,
                fontSize: getProportionateScreenWidth(textSize),
              ),
            ),
          ),
      ],
    );
  }
}
