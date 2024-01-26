import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'auth_components/alertToast.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_components/auth_title.dart';
import 'auth_page_transition/slid_right_transition.dart';
import 'login_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  static String routeName = "/CreateNewPasswordScreen";

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  String oldPassword = " ";
  String newPassword = " ";
  String confirmPassword = " ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAuthMainColor,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            child: Stack(
              children: [
                arrowBackButton(context),
                Positioned(
                  top: getProportionateScreenHeight(241),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: getProportionateScreenHeight(572),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white,
                    ),
                  ),
                ),
                //image
                Positioned(
                    top: getProportionateScreenHeight(113),
                    left: getProportionateScreenWidth(85),
                    child: Container(
                      width: getProportionateScreenWidth(205),
                      height: getProportionateScreenHeight(158),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/auth_images/Secure data-pana@1X.png"),
                            fit: BoxFit.contain),
                      ),
                    )),
                authTitle("Create new password", 344, 78),
                Positioned(
                  top: getProportionateScreenHeight(393),
                  left: getProportionateScreenWidth(27),
                  child: Container(
                    width: getProportionateScreenWidth(321),
                    height: getProportionateScreenHeight(50),
                    child: Center(
                      child: Text(
                        "Your new password must be different from previously used password.",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          color: kTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                //enter password Text Form Field
                Positioned(
                  top: getProportionateScreenHeight(450),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          oldPassword = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Enter Your Old Password",
                        prefixIcon:
                            Icon(Icons.lock_open, color: Color(0xffA0BBF0)),
                      ),
                    ),
                  ),
                ),
                //confirm password field
                Positioned(
                  top: getProportionateScreenHeight(530),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          newPassword = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your New Password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: getProportionateScreenHeight(610),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Confirm your Password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                authButton("Save", () async {
                  if (oldPassword != '' &&
                      newPassword != '' &&
                      confirmPassword != '') {
                    if (newPassword == confirmPassword) {
                      try {
                        var url = Uri.parse(
                            'https://masla7a.herokuapp.com/my-profile/reset-password');
                        var response = await http.post(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            "current_password": oldPassword,
                            "new_password": newPassword,
                            "confirm_password": confirmPassword
                          }),
                        );
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');
                        var result = json.decode(response.body);
                        if (response.statusCode == 200) {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString("token", result["token"]);
                          pref.setBool("isAuth", true);
                          Navigator.push(
                              context, SlidRight(page: LoginScreen()));
                        }
                      } catch (ex) {
                        alertToast("$ex", Colors.red, Colors.white);
                        print("error with login $ex");
                      }
                    } else {
                      alertToast(
                          "Passwords Not Match ..!", Colors.red, Colors.white);
                    }
                  } else {
                    alertToast(
                        "Please Provide All Data", Colors.red, Colors.white);
                  }
                }, 720, 71),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
