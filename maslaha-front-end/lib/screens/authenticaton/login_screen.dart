import 'dart:convert';

import 'auth_components/alertToast.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_page_transition/slid_right_transition.dart';
import 'create_new_password_screen.dart';
import 'register_screen_1.dart';
import '../home/home_screen.dart';
import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_components/auth_title.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool isLoading = false;
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
                  top: getProportionateScreenHeight(283),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: getProportionateScreenHeight(529),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white,
                    ),
                  ),
                ),
                // login Image
                Positioned(
                    top: getProportionateScreenHeight(69),
                    left: getProportionateScreenWidth(63),
                    child: Container(
                      width: getProportionateScreenWidth(261),
                      height: getProportionateScreenHeight(246),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/auth_images/Login-pana@1X.png"),
                            fit: BoxFit.contain),
                      ),
                    )),
                authTitle("Welcome", 350, 140),
                //Email text form field
                Positioned(
                  top: getProportionateScreenHeight(410),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Enter your Email",
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Color(0xffA0BBF0)),
                      ),
                    ),
                  ),
                ),
                //password text form field
                Positioned(
                  top: getProportionateScreenHeight(500),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(37),
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Enter your Password",
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                authButton(isLoading ? "Loading" : "Log in", () async {
                  if (email != '' && password != '') {
                    if (email.contains("@")) {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        print("this is email $email");
                        print("this is password $password");
                        var url = Uri.parse(
                            'https://masla7a.herokuapp.com/accounts/login');
                        var response = await http.post(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            'email': email,
                            'password': password
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
                          pref.setString("id", result["_id"]);
                          Navigator.push(
                              context, SlidRight(page: HomeScreen()));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (ex) {
                        alertToast("$ex", Colors.red, Colors.white);
                        print("error with login $ex");
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      alertToast("Please Provide Valid Email", Colors.red,
                          Colors.white);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    alertToast(
                        "Please Provide All Data", Colors.red, Colors.white);
                    setState(() {
                      isLoading = false;
                    });
                  }
                }, 630, 71),
                Positioned(
                  top: getProportionateScreenHeight(700),
                  left: getProportionateScreenWidth(82),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account yet? ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(13.5)),
                        ),
                        GestureDetector(
                          onTap: () {
                            //Normal Navigate
                            //Navigator.pushNamed(context,RegisterScreen1.routeName);
                            //Slid right Navigate
                            Navigator.of(context)
                                .push(SlidRight(page: RegisterScreen1()));
                          },
                          child: Text('Sign up',
                              style: TextStyle(
                                  color: kAuthMainColor,
                                  fontSize: getProportionateScreenWidth(13.5))),
                        ),
                      ],
                    ),
                  ),
                ),
                //Forget password Screen
//                Positioned(
//                  top: getProportionateScreenHeight(740),
//                  left: getProportionateScreenWidth(133),
//                  child: GestureDetector(
//                    onTap: () {
//                      //Normal Navigate
//                      //Navigator.pushNamed(context, ForgetPasswordScreen.routeName);
//                      //Slid right Navigate
//                      Navigator.of(context)
//                          .push(SlidRight(page: CreateNewPasswordScreen()));
//                    },
//                    child: Text(
//                      "Forget Password?",
//                      style: TextStyle(
//                        color: kAuthMainColor,
//                      ),
//                    ),
//                  ),
//                ),
                //OR Row
//                Positioned(
//                  top: getProportionateScreenHeight(698),
//                  child: Padding(
//                    padding: EdgeInsets.only(
//                      left: getProportionateScreenWidth(37),
//                      right: getProportionateScreenWidth(37),
//                    ),
//                    child: Row(
//                      children: [
//                        Container(
//                          width: getProportionateScreenWidth(140),
//                          child: Divider(
//                            //color:kFieldBorder,
//                            thickness: 2,
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 5, right: 5),
//                          child: Text(
//                            "Or",
//                            style: TextStyle(fontSize: 16),
//                          ),
//                        ),
//                        Container(
//                          width: getProportionateScreenWidth(140),
//                          child: Divider(
//                            thickness: 2,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
                //social buttons
//                Positioned(
//                  top: getProportionateScreenHeight(740),
//                  left: getProportionateScreenWidth(116),
//                  child: socialButton(
//                      FontAwesomeIcons.google, () {}, Color(0xffB90B0B)),
//                ),
//                Positioned(
//                  top: getProportionateScreenHeight(740.0),
//                  left: getProportionateScreenWidth(213.0),
//                  child: socialButton(
//                      FontAwesomeIcons.facebookF, () {}, Color(0xff064FAE)),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
