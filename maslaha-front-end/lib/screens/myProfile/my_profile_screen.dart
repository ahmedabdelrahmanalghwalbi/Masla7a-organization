import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maslaha/screens/myProfile/components/about_me.dart';
import 'package:maslaha/screens/myProfile/components/appBar_profile.dart';
import 'package:maslaha/screens/myProfile/components/bio.dart';
import 'package:maslaha/screens/myProfile/components/profile_pic_shader_mask.dart';
import 'package:maslaha/screens/myProfile/components/rating_and_reviews.dart';
import 'package:maslaha/screens/myProfile/components/work_gallery.dart';
import 'package:maslaha/screens/profile/components/about_me.dart';
import 'package:maslaha/screens/profile/components/appBar_profile.dart';
import 'package:maslaha/screens/profile/components/bio.dart';
import 'package:maslaha/screens/profile/components/profile_pic_shader_mask.dart';
import 'package:maslaha/screens/profile/components/rating_and_reviews.dart';
import 'package:maslaha/screens/profile/components/social_buttons.dart';
import 'package:maslaha/screens/profile/components/star_rating_line.dart';
import 'package:maslaha/screens/profile/components/work_gallery.dart';
import 'package:maslaha/screens/profile/schedual/schedual.dart';
import 'package:maslaha/utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = '/my-profile';
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Map data = {};
  String serviceProviderId = '';
  fetchProfileInfo() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse(
            'https://masla7a.herokuapp.com/my-profile/${_pref.getString("id").toString()}'),
        headers: {"x-auth-token": _pref.getString("token").toString()});
    if (response.statusCode == 200) {
      print("this is the jsoooooooooon ${jsonDecode(response.body)}");
      setState(() {
        data = jsonDecode(response.body);
      });
      return jsonDecode(response.body);
    } else {
      print(response.body.toString());
      throw Exception('Failed to load album');
    }
  }

  bool isOpened = false;
  double rating = 3.0;
  double getWhitePanelHeight() {
    if (isOpened == false) {
      return getProportionateScreenHeight(317);
    } else if (isOpened == true) {
      return getProportionateScreenHeight(711);
    } else {
      return getProportionateScreenHeight(317);
    }
  }

  setUserId() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      serviceProviderId = pre.getString('id').toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfileInfo();
    setUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: data.isNotEmpty
          ? SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    //profile pic
                    MyProfilePicShaderMask(
                        image: data["serviceProviderInfo"]["profilePic"]),
                    MyAppBarProfile(serviceProviderId: serviceProviderId),
                    //info part with (Send a request) button
//              Positioned(
//                top:getProportionateScreenHeight(326),
//                child: Container(
//                    padding: EdgeInsets.only(top: getProportionateScreenHeight(110)),
//                    width:MediaQuery.of(context).size.width,
//                    height: getProportionateScreenHeight(215),
//                    decoration: BoxDecoration(
//                        color: Colors.black.withOpacity(.2)
//                    ),
//                    child:Column(
//                      children: [
//                        GestureDetector(
//                          onTap:(){
//                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Schedual()));
//                          },
//                          child: Container(
//                            width: getProportionateScreenWidth(343),
//                            height: getProportionateScreenHeight(45),
//                            child: Center(
//                              child: Text("Send A Request",style: TextStyle(
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: getProportionateScreenWidth(16)
//                              ),),
//                            ),
//                            decoration: BoxDecoration(
//                                color: Color(0xff4378E3),
//                                borderRadius: BorderRadius.circular(10),
//                                boxShadow: [
//                                  BoxShadow(
//                                      color: Color(0xff4378E3),
//                                      spreadRadius: .2,
//                                      blurRadius: 10,
//                                      offset: Offset(0,1)
//                                  )
//                                ]
//                            ),
//                          ),
//                        ),
//                      ],
//                    )
//                ),
//              ),
//              SocialButtons(),
//              Positioned(
//                top:getProportionateScreenHeight(393),
//                left: getProportionateScreenWidth(264),
//                child:BioInformation(fontSize: 13,color: Color(0xffFFDF00), title: data["service"]["averageRating"], fIcon: FontAwesomeIcons.solidStar, iconSize: 17.0),
//
//              ),
                    Positioned(
                        top: getProportionateScreenHeight(336),
                        left: getProportionateScreenWidth(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyBioInformation(
                                fontSize: 17,
                                color: Color(0xff30E423),
                                title: data["serviceProviderInfo"]["name"],
                                fIcon: FontAwesomeIcons.solidCircle,
                                iconSize: 17.0),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: getProportionateScreenHeight(3)),
                              child: MyBioInformation(
                                  fontSize: 13,
                                  color: Color(0xffffffff),
                                  title: data["service"]["serviceName"],
                                  fIcon: FontAwesomeIcons.archive,
                                  iconSize: 17.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(5),
                                  bottom: getProportionateScreenHeight(3)),
                              child: MyBioInformation(
                                  fontSize: 13,
                                  color: Color(0xffE92B2B),
                                  title: data["serviceProviderInfo"]["address"],
                                  fIcon: FontAwesomeIcons.mapMarkerAlt,
                                  iconSize: 17.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(3),
                                  bottom: getProportionateScreenHeight(3)),
                              child: MyBioInformation(
                                  fontSize: 13,
                                  color: Color(0xffE92B2B),
                                  title: data["serviceProviderInfo"]
                                      ["phone_number"],
                                  fIcon: FontAwesomeIcons.phone,
                                  iconSize: 17.0),
                            ),
                          ],
                        )),
                    //second column
                    Positioned(
                        top: getProportionateScreenHeight(336),
                        right: getProportionateScreenWidth(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyBioInformation(
                                fontSize: 17,
                                color: Color(0xff30E423),
                                title:
                                    data["service"]["servicePrice"].toString(),
                                fIcon: FontAwesomeIcons.tags,
                                iconSize: 17.0),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionateScreenHeight(3),
                                  bottom: getProportionateScreenHeight(3)),
                              child: MyBioInformation(
                                  fontSize: 13,
                                  color: Color(0xffE92B2B),
                                  title: data["serviceProviderInfo"]["age"]
                                      .toString(),
                                  fIcon: FontAwesomeIcons.userClock,
                                  iconSize: 17.0),
                            ),
//                      Padding(
//                        padding: EdgeInsets.only(bottom: getProportionateScreenHeight(3)),
//                        child: BioInformation(fontSize: 13,color: Color(0xffffffff), title: data["serviceProviderInfo"]["gender"], fIcon:FontAwesomeIcons.venusMars, iconSize: 17.0),
//                      ),
                          ],
                        )),
                    //animated modal bottom sheet
                    Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          print(details.primaryDelta);
                          if (details.primaryDelta! < -1) {
                            setState(() {
                              isOpened = true;
                            });
                          } else if (details.primaryDelta! > 1) {
                            setState(() {
                              isOpened = false;
                            });
                          } else {
                            setState(() {
                              isOpened = false;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width,
                          height: getWhitePanelHeight(),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: Colors.white),
                          child: Column(
                            children: [
                              //sheet notch
                              Container(
                                width: getProportionateScreenWidth(72),
                                height: getProportionateScreenHeight(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey),
                                margin: EdgeInsets.only(
                                    top: getProportionateScreenWidth(10)),
                              ),
                              MyAboutMe(
                                  text: data["service"]["description"] == null
                                      ? ""
                                      : data["service"]["description"]),
                              MyWorkGallery(
                                  gallery: data["service"]["gallery"]),
                              MyRatingAndReviews(
                                ratings: data["reviewsDetails"],
                                serviceProviderId: serviceProviderId,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
    );
  }
}
