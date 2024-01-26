import 'package:flutter/material.dart';
import 'package:maslaha/screens/myProfile/my_profile_screen.dart';
import 'package:maslaha/screens/profile/profile_screen.dart';
import 'package:maslaha/utils/getServiceProviderProfile.dart';
import 'login_screen.dart';
import 'sign_up_as_client.dart';
import 'sign_up_as_worker.dart';
import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'auth_components/alertToast.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_components/auth_title.dart';
import 'auth_page_transition/slid_right_transition.dart';

class RegisterScreen1 extends StatefulWidget {
  static String routeName = "/RegisterScreen1";
  @override
  _RegisterScreen1State createState() => _RegisterScreen1State();
}

class _RegisterScreen1State extends State<RegisterScreen1> {
  bool _clientValue = true;
  bool _serviceProviderValue = false;
  String email = '';
  String password = '';
  String rePassword = '';

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
                //image
                Positioned(
                    top: getProportionateScreenHeight(50),
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
                authTitle("Create Account", 330, 109),
                //Email Field
                Positioned(
                  top: getProportionateScreenHeight(370),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.top,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your Email",
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xffA0BBF0),
                          size: 30,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ),
                //password Field
                Positioned(
                  top: getProportionateScreenHeight(440),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Enter your Password",
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                //re-enter the password
                Positioned(
                  top: getProportionateScreenHeight(520),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          rePassword = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Re-Enter Your Password",
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                //client or service provider check buttons
                Positioned(
                    top: getProportionateScreenHeight(610),
                    left: getProportionateScreenWidth(37),
                    child: Row(
                      children: [
                        Container(
                          height: getProportionateScreenHeight(45),
                          width: getProportionateScreenWidth(119),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _clientValue
                                      ? Colors.blueAccent
                                      : Colors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _clientValue = true;
                                      _serviceProviderValue = false;
                                    });
                                  },
                                  child: Container(
                                    width: getProportionateScreenHeight(20),
                                    height: getProportionateScreenHeight(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Color(0xFF979797)),
                                        color: _clientValue == true
                                            ? Colors.blueAccent
                                            : Colors.white),
                                  ),
                                ),
                                Text(
                                  "Client",
                                  style: TextStyle(
                                      color: _clientValue == true
                                          ? Colors.blueAccent
                                          : Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: getProportionateScreenWidth(10)),
                          height: getProportionateScreenHeight(45),
                          width: getProportionateScreenWidth(173),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _serviceProviderValue
                                      ? Colors.blueAccent
                                      : Colors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _serviceProviderValue = true;
                                      _clientValue = false;
                                    });
                                  },
                                  child: Container(
                                    width: getProportionateScreenHeight(20),
                                    height: getProportionateScreenHeight(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Color(0xFF979797)),
                                        color: _serviceProviderValue == true
                                            ? Colors.blueAccent
                                            : Colors.white),
                                  ),
                                ),
                                Text(
                                  "Service Provider",
                                  style: TextStyle(
                                      color: _serviceProviderValue == true
                                          ? Colors.blueAccent
                                          : Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                authButton("Next", () {
                  if (email != '' && password != '' && rePassword != '') {
                    if (password == rePassword) {
                      if (email.contains("@")) {
                        if (_clientValue) {
                          Navigator.of(context).push(SlidRight(
                              page: SignUpAsClient(
                                  password: password, email: email)));
                        } else if (_serviceProviderValue) {
                          Navigator.of(context).push(SlidRight(
                              page: SignUpAsWorker(
                                  password: password, email: email)));
                        }
                      } else {
                        alertToast("Please Provide Valid Email", Colors.red,
                            Colors.white);
                      }
                    } else {
                      alertToast(
                          "Password Not Match ...!", Colors.red, Colors.white);
                    }
                  } else {
                    alertToast(
                        "Please provide all data", Colors.red, Colors.white);
                  }

//                  Navigator.of(context)
//                      .push(SlidRight(page:_clientValue?SignUpAsClient():SignUpAsWorker()));
                }, 680, 71),
                //already have an account line
                Positioned(
                  top: getProportionateScreenHeight(740),
                  left: getProportionateScreenWidth(89),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(13.5)),
                        ),
                        GestureDetector(
                          onTap: () {
                            //normal navigate
                            //Navigator.pushNamed(context,LoginScreen.routeName);
                            //Slid right Navigate
                            Navigator.of(context)
                                .push(SlidRight(page: LoginScreen()));
//                         getServiceProviderProfile(context, "60fe1b13c36de77e70406acd");
                          },
                          child: Text('Login',
                              style: TextStyle(
                                  color: kAuthMainColor,
                                  fontSize: getProportionateScreenWidth(13.5))),
                        ),
                      ],
                    ),
                  ),
                ),
                //OR row
//                Positioned(
//                  top: getProportionateScreenHeight(740),
//                  child: Padding(
//                    padding: EdgeInsets.only(
//                      left: getProportionateScreenWidth(39),
//                      right: getProportionateScreenWidth(39),
//                    ),
//                    child: Row(
//                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
//                  top: getProportionateScreenHeight(760),
//                  left: getProportionateScreenWidth(116),
//                  child: socialButton(
//                      FontAwesomeIcons.google, () {}, Color(0xffB90B0B)),
//                ),
//                Positioned(
//                  top: getProportionateScreenHeight(760),
//                  left: getProportionateScreenWidth(213),
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
