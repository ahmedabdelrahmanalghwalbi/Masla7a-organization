import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_components/auth_title.dart';

class RegisterScreen2 extends StatefulWidget {
  static String routeName = "/RegisterScreen2";

  @override
  _RegisterScreen2State createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  bool _value = false;
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
                  top: getProportionateScreenHeight(301),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: getProportionateScreenHeight(512),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: Colors.white,
                    ),
                  ),
                ),
                //Image
                Positioned(
                    top: getProportionateScreenHeight(58),
                    left: getProportionateScreenWidth(71),
                    child: Container(
                      width: getProportionateScreenWidth(204),
                      height: getProportionateScreenHeight(269),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/auth_images/Mobile login-pana@1X.png"),
                            fit: BoxFit.contain),
                      ),
                    )),
                authTitle("Create Account", 369, 109),
                //password field
                Positioned(
                  top: getProportionateScreenHeight(423),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        prefixIcon:
                            Icon(Icons.lock_open, color: Color(0xffA0BBF0)),
                      ),
                    ),
                  ),
                ),
                //re-enter password field
                Positioned(
                  top: getProportionateScreenHeight(490),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Re-enter your Password",
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                //circular check box
                Positioned(
                  top: getProportionateScreenHeight(573),
                  left: getProportionateScreenWidth(39),
                  child: Center(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        _value = !_value;
                      });
                    },
                    child: Container(
                      width: getProportionateScreenWidth(20),
                      height: getProportionateScreenHeight(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFF979797)),
                      ),
                      child: Center(
                        child: _value
                            ? Icon(
                                Icons.check,
                                size: getProportionateScreenHeight(20),
                                color: kAuthMainColor,
                              )
                            : Icon(
                                Icons.circle,
                                size: getProportionateScreenHeight(1),
                                color: Colors.white,
                              ),
                      ),
                    ),
                  )),
                ),
                Positioned(
                  top: getProportionateScreenHeight(572),
                  left: getProportionateScreenWidth(67),
                  child: Container(
                    width: getProportionateScreenWidth(272),
                    height: getProportionateScreenHeight(50),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(11.5)),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  'By creating an account you agree to our terms of '),
                          TextSpan(
                              text: "Service, Privacy Policy, ",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: kAuthMainColor)),
                          TextSpan(text: 'and our default '),
                          TextSpan(
                              text: "Notification Settings.",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: kAuthMainColor)),
                        ],
                      ),
                    ),
                  ),
                ),
                authButton("Sign up", () {}, 672, 71),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
