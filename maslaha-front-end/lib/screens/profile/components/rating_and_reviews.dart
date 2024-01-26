import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maslaha/screens/authenticaton/auth_components/alertToast.dart';
import 'package:maslaha/screens/profile/components/list_item_ratings_and_reviews.dart';
import 'package:maslaha/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'star_rating_line.dart';
import 'package:http/http.dart'as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RatingAndReviews extends StatefulWidget {
  List ratings;
  var serviceProviderId;
  RatingAndReviews({required this.ratings,this.serviceProviderId});
  @override
  _RatingAndReviewsState createState() => _RatingAndReviewsState();
}

class _RatingAndReviewsState extends State<RatingAndReviews> {
  double rating =0;
  bool isLoading=false;
  String content="";
  @override
  Widget build(BuildContext context) {
    return widget.ratings.length!=0?Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: getProportionateScreenWidth(350),
              height: getProportionateScreenHeight(500),
              child: Stack(
                  children: [
                    Column(
                      children: [
                        //Rating And Reviews Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ratings And Reviews',style: TextStyle(
                                fontSize: getProportionateScreenWidth(14),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: .8
                            ),
                            ),
                            TextButton(
                              onPressed: (){},
                              child: Text("More Relevent >",style: TextStyle(
                                  fontSize: getProportionateScreenWidth(12),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff5585E5),
                                  letterSpacing: .8
                              ),),
                            ),
                          ],
                        ),
                        //List view Tiles in List View(Comments)
                        Container(
                          height: getProportionateScreenHeight(300),
                          child: ListView(
                              scrollDirection: Axis.vertical,
                              children:widget.ratings.map((rating){
                                return ListItemRatingsAndReviews(
                                  image: rating["user"]["profilePic"],
                                  userName:rating["user"]["name"],
                                  rating: rating["rating"],
                                  description: rating["content"],
                                );
                              }).toList()
                          ),
                        ),
                      ],
                    ),
                    //Send A request button
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          Container(
                            margin:EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
                            width: getProportionateScreenWidth(343),
                            height: getProportionateScreenWidth(50),
                            child: TextFormField(
                              onChanged: (val){
                                setState(() {
                                  content=val;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Write a review ...",
                                  hintStyle:TextStyle(
                                      color: Color(0xffC4C5C9),
                                      fontSize: getProportionateScreenHeight(15)
                                  ),
                                  suffixIcon: Container(
                                      width: getProportionateScreenWidth(130),
                                      height: getProportionateScreenHeight(12),
                                      child: StarRating(onRatingChanged: (rating) => setState(() =>this.rating = rating),color: Colors.yellow,rating: rating,)),
                                  prefixIcon:Icon(Icons.emoji_emotions,size: getProportionateScreenHeight(30),),
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  fillColor: Color(0xffF1F2F6),
                                  filled: true
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              print("this is the content ..... $content");
                              print("this is the rating ...... ${rating.toInt()} ");
                              if(rating !=0.0 && content !=""){
                                setState(() {
                                  isLoading=true;
                                });
                                SharedPreferences pref=await SharedPreferences.getInstance();
                                http.post(
                                  Uri.parse('https://masla7a.herokuapp.com/my-profile/${widget.serviceProviderId}/reviews'),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                    'x-auth-token':pref.getString("token").toString()
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    "title": "rating title",
                                    "content": content,
                                    "rating": rating.toInt()
                                  }),
                                ).then((value){
                                  print("your review added successfully ${jsonDecode(value.body)["message"]}");
                                  alertToast(jsonDecode(value.body)["message"],Colors.blue, Colors.blue);
                                  setState(() {
                                    isLoading=false;
                                  });
                                }).catchError((ex){
                                  print("error with adding your review ${ex}");
                                  alertToast(ex,Colors.blue, Colors.white);
                                  setState(() {
                                    isLoading=false;
                                  });
                                });
                              }else{
                                alertToast("Please Provide your Rating and Content ..!", Colors.blue, Colors.white);
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            },
                            child: Container(
                              width: getProportionateScreenWidth(343),
                              height: getProportionateScreenHeight(45),
                              child: Center(
                                child:isLoading?CircularProgressIndicator(color: Colors.white,):Text("Send A Review",style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: getProportionateScreenWidth(16)
                                ),),
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xff4378E3),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xff4378E3),
                                        spreadRadius: .2,
                                        blurRadius: 10,
                                        offset: Offset(0,1)
                                    )
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            ),],
        ),
      ),
    ):Center(child: Text("Ratings and Reviews",style: TextStyle(
        color:Colors.black,
        fontWeight: FontWeight.bold
    ),),);
  }
}
