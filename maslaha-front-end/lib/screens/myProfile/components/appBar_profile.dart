import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maslaha/screens/authenticaton/auth_components/alertToast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyAppBarProfile extends StatefulWidget {
//  var rating;
  var serviceProviderId;
  MyAppBarProfile({this.serviceProviderId});

  @override
  _MyAppBarProfileState createState() => _MyAppBarProfileState();
}

class _MyAppBarProfileState extends State<MyAppBarProfile> {
  bool isRed=false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 43,
        left: 15,
        right: 15,
        child:Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Icon(Icons.arrow_back_ios,size: 40,color: Colors.white,),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
//              GestureDetector(
//                child:isRed?Icon(Icons.favorite,size:40,color: Colors.red,):Icon(Icons.favorite_border,size: 40,color: Colors.white,),
//                onTap:isRed?()async{
//                  SharedPreferences pref=await SharedPreferences.getInstance();
//                  var  response = http.get(
//                    Uri.parse('https://masla7a.herokuapp.com/favourites/remove-favourite/60f59da1b97f2e96fce9a599'),
//                    headers: <String, String>{
//                      'Content-Type': 'application/json; charset=UTF-8',
//                      'x-auth-token':"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGY1OWQ3ZmI5N2YyZTk2ZmNlOWE1OTciLCJlbWFpbCI6ImthcmltYWxhYTE5QGdtYWlsLmNvbSIsInVzZXJOYW1lIjoiS2FyaW0xOSIsInJvbGUiOiJzZXJ2aWNlUHJvdmlkZXIiLCJnb3RBZGRyZXNzIjp0cnVlLCJpYXQiOjE2MjY3MDkzNzd9.5ep1qCzoogSgHCQwpegHUEg3Zy_-ESS9wi-dvicx96Y"
//                    },
//                  ).then((value){
//                    print("deleted successfully ${value.body}");
//                    setState(() {
//                      isRed=false;
//                    });
//                  }).catchError((ex){
//                    print("error with deleting ${ex}");
//                    alertToast(ex,Colors.blue, Colors.white);
//                    setState(() {
//                      isRed=false;
//                    });
//                  });
//                }: ()async{
//                  SharedPreferences pref=await SharedPreferences.getInstance();
//                  var  response = http.post(
//                    Uri.parse('https://masla7a.herokuapp.com/favourites/add-favourite/'),
//                    headers: <String, String>{
//                      'Content-Type': 'application/json; charset=UTF-8',
//                      'x-auth-token':"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGY1OWQ3ZmI5N2YyZTk2ZmNlOWE1OTciLCJlbWFpbCI6ImthcmltYWxhYTE5QGdtYWlsLmNvbSIsInVzZXJOYW1lIjoiS2FyaW0xOSIsInJvbGUiOiJzZXJ2aWNlUHJvdmlkZXIiLCJnb3RBZGRyZXNzIjp0cnVlLCJpYXQiOjE2MjY3MDkzNzd9.5ep1qCzoogSgHCQwpegHUEg3Zy_-ESS9wi-dvicx96Y"
//                    },
//                    body: jsonEncode(<String, String>{
//                      'serviceProviderId': "60f59da1b97f2e96fce9a599",
//                    }),
//                  ).then((value){
//                    print("sssssssssss ${value.body}");
//                    setState(() {
//                      isRed=true;
//                    });
//                  }).catchError((ex){
//                    print("fffffffffffffffffff ${ex}");
//                    alertToast(ex,Colors.blue, Colors.white);
//                    setState(() {
//                      isRed=true;
//                    });
//                  });
//                },
//              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(4),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.star,color: Colors.yellow,),
                    SizedBox(
                      width: 2,
                    ),
                    Text('3',style: TextStyle(
                      color: Colors.black
                    ),),
                    SizedBox(
                      width: 2,
                    ),
                  ],
                ),
              ),
            )
            ],
          ),
        ));
  }
}
