import 'package:flutter/material.dart';
import 'star_rating_line.dart';
import '../../../utils/size_config.dart';

class MyListItemRatingsAndReviews extends StatefulWidget {
  var userName;
  var rating;
  var description;
  var image;
  MyListItemRatingsAndReviews(
      {this.rating, this.description, this.userName, this.image});
  @override
  _MyListItemRatingsAndReviewsState createState() =>
      _MyListItemRatingsAndReviewsState();
}

class _MyListItemRatingsAndReviewsState extends State<MyListItemRatingsAndReviews> {
  double rating = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    rating=double.tryParse(widget.rating)!.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
      child: Container(
        width: getProportionateScreenWidth(343),
        height: getProportionateScreenHeight(70),
        child: Row(
          children: [
            Container(
              width: getProportionateScreenWidth(50),
              height: getProportionateScreenWidth(50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.contain)),
            ),
            Container(
              margin: EdgeInsets.only(left: getProportionateScreenWidth(10)),
              height: getProportionateScreenHeight(70),
              width: getProportionateScreenWidth(276),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.userName.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(16),
                            fontWeight: FontWeight.bold),
                      ),
                      //Rating Stars
                      MyStarRating(
                          onRatingChanged: (rating) =>
                              setState(() => this.rating = rating),
                          color: Colors.yellow,
                          rating: rating),
                    ],
                  ),
                  Text(widget.description.toString(),
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(10),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4D4D4D)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
