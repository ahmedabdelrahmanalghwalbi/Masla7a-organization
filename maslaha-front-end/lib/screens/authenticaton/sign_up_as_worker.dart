import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'auth_components/alertToast.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_components/auth_title.dart';
import 'auth_page_transition/slid_right_transition.dart';
import 'sign_up_as_worker2.dart';

class SignUpAsWorker extends StatefulWidget {
  late String email;
  late String password;
  SignUpAsWorker({required this.email, required this.password});
  static String routeName = "/SignUpAsWorker";
  @override
  _SignUpAsWorkerState createState() => _SignUpAsWorkerState();
}

class _SignUpAsWorkerState extends State<SignUpAsWorker> {
  bool _male = true;
  bool _female = false;
  String name = '';
  String birthDate = "";
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
                authTitle("Personal Info", 325, 115),
                //image Picker for personal information
                Positioned(
                  top: getProportionateScreenHeight(380),
                  left: getProportionateScreenWidth(140),
                  child: Container(
                    width: getProportionateScreenHeight(120),
                    height: getProportionateScreenHeight(120),
                    decoration: BoxDecoration(
                        image: _image == null
                            ? DecorationImage(
                                image:
                                    AssetImage('assets/images/user_male.png'))
                            : DecorationImage(
                                image: FileImage(_image!), fit: BoxFit.contain),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(300)),
                  ),
                ),
                // add photo camera Icon
                Positioned(
                  top: getProportionateScreenHeight(375),
                  left: getProportionateScreenWidth(210),
                  child: GestureDetector(
                    onTap: () async {
                      await getImage();
                    },
                    child: Container(
                      width: getProportionateScreenHeight(40),
                      height: getProportionateScreenHeight(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
//                        border: Border.all(color: Colors.grey),
                        color: Color(0xff3669CB),
                      ),
                      child: Center(
                          child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),
                //Full Name Field
                Positioned(
                  top: getProportionateScreenHeight(510),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Enter your Full Name",
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                //Gender check buttons
                Positioned(
                  top: getProportionateScreenHeight(610),
                  left: getProportionateScreenWidth(37),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(20),
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Container(
                              height: getProportionateScreenHeight(50),
                              width: getProportionateScreenWidth(120),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _male
                                          ? Colors.blueAccent
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _male = true;
                                          _female = false;
                                        });
                                      },
                                      child: Container(
                                        width: getProportionateScreenHeight(20),
                                        height:
                                            getProportionateScreenHeight(20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Color(0xFF979797)),
                                            color: _male == true
                                                ? Colors.blueAccent
                                                : Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "Male",
                                      style: TextStyle(
                                          color: _male == true
                                              ? Colors.blueAccent
                                              : Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(62)),
                              height: getProportionateScreenHeight(50),
                              width: getProportionateScreenWidth(120),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _female
                                          ? Colors.blueAccent
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _female = true;
                                          _male = false;
                                        });
                                      },
                                      child: Container(
                                        width: getProportionateScreenHeight(20),
                                        height:
                                            getProportionateScreenHeight(20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Color(0xFF979797)),
                                            color: _female == true
                                                ? Colors.blueAccent
                                                : Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "Female",
                                      style: TextStyle(
                                          color: _female == true
                                              ? Colors.blueAccent
                                              : Colors.grey),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                authButton("Next", () {
                  if (_image != null && name != null) {
                    Navigator.of(context).push(SlidRight(
                        page: SignUpAsWorker2(
                      password: widget.password,
                      email: widget.email,
                      name: name,
                      photo: _image,
                      gender: _male ? "male" : "female",
                    )));
                  } else {
                    alertToast(
                        "Please Provide All Data", Colors.red, Colors.white);
                  }
                }, 740, 71),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
