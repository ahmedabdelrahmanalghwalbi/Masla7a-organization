import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class MyStarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color? color;

  MyStarRating({this.starCount = 5, required this.rating , required this.onRatingChanged, required this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}