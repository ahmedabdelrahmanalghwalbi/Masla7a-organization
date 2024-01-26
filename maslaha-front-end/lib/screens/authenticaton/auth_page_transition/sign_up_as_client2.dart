import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/constants.dart';
import '../../../utils/size_config.dart';
import '../../home/home_screen.dart';
import '../auth_components/alertToast.dart';
import '../auth_components/arrow_back_button.dart';
import '../auth_components/auth_button.dart';
import '../auth_components/auth_title.dart';
import 'slid_right_transition.dart';

class SignUpAsClient2 extends StatefulWidget {
  late String gender;
  late File? photo;
  late String email;
  late String password;
  late String name;
  SignUpAsClient2(
      {required this.gender,
      required this.email,
      required this.password,
      required this.name,
      required this.photo});
  @override
  _SignUpAsClient2State createState() => _SignUpAsClient2State();
}

class _SignUpAsClient2State extends State<SignUpAsClient2> {
  String birthDate = "";
  String phone = "";
  String nationalID = '';
  String address = '';
  bool isLoading = false;
  String deviceToken = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        deviceToken = value!;
      });
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
                authTitle("Personal Info", 325, 135),
                //select birth date buttons
                Positioned(
                    top: getProportionateScreenHeight(370),
                    left: getProportionateScreenWidth(37),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1960, 1, 1),
                              maxTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            setState(() {
                              var day = date.day < 10
                                  ? "0" + date.day.toString()
                                  : date.day.toString();
                              var month = date.month < 10
                                  ? "0" + date.month.toString()
                                  : date.month.toString();
                              birthDate = "$day/$month/${date.year.toString()}";
                            });
                            print(birthDate);
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.ar);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Birth date",
                              style: TextStyle(
                                  fontSize: getProportionateScreenHeight(20),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                                padding: EdgeInsets.all(8),
                                width: getProportionateScreenWidth(300),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: birthDate == ""
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Select your BirthDate",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        20)),
                                          ),
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.blue,
                                          )
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Birth Date",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        20)),
                                          ),
                                          Text(
                                            birthDate,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        20)),
                                          ),
                                        ],
                                      )),
                          ],
                        ),
                      ),
                    )),
                //ID Number Field
                Positioned(
                  top: getProportionateScreenHeight(470),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          nationalID = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "ID Number",
                        prefixIcon: Icon(
                          Icons.account_box_outlined,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                //phone number Field
                Positioned(
                  top: getProportionateScreenHeight(555),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          phone = val;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Phone Number",
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                //location Field
                Positioned(
                  top: getProportionateScreenHeight(640),
                  left: getProportionateScreenWidth(37),
                  child: Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    width: getProportionateScreenWidth(302),
//                    height: getProportionateScreenHeight(36),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          address = val;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffE4DCDC)),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Location",
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xffA0BBF0),
                        ),
                      ),
                    ),
                  ),
                ),
                authButton(isLoading ? "Loading" : "Sign Up", () async {
                  if (birthDate != "" &&
                      nationalID != "" &&
                      phone != "" &&
                      address != "") {
//                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VerifyYourEmailClient(nationalID: nationalID, birthDate: birthDate, address: address, phone: phone, gender: widget.gender, email: widget.email, password: widget.password, name: widget.name)));
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      var url = Uri.parse(
                          'https://masla7a.herokuapp.com/accounts/sign-up');
                      var request = http.MultipartRequest('POST', url);
                      final file = await http.MultipartFile.fromPath(
                          "profilePic", widget.photo!.path);
                      request.files.add(file);
                      request.fields["name"] = widget.name;
                      request.fields["deviceToken"] = deviceToken;
                      request.fields["email"] = widget.email;
                      request.fields["password"] = widget.password;
//                    request.fields["confirm_password"]=widget.password;
                      request.fields["birthDate"] = "06/02/1988";
                      request.fields["nationalID"] = nationalID;
                      request.fields["phone_number"] = phone;
                      request.fields["gender"] = widget.gender;
                      request.fields["userName"] = widget.name;
                      request.fields["role"] = "customer";
//        "3 Shaaker El Gendi St.- El Sharabia - Cairo - Egypt"
                      request.fields["address"] =
                          "3 Shaaker El Gendi St.- El Sharabia - Cairo - Egypt";
                      var response = await request.send();
                      final respStr = await response.stream.bytesToString();
                      var result = json.decode(respStr);
                      print(respStr);
                      print(birthDate);
                      print("this is the token ${result["token"]}");
                      setState(() {
                        isLoading = false;
                      });
                      if (response.statusCode == 200) {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString("token", result["token"]);
                        pref.setString("id", result["_id"]);
                        pref.setBool("isAuth", true);
                        Navigator.of(context)
                            .push(SlidRight(page: HomeScreen()));
                      }
                    } catch (ex) {
                      setState(() {
                        isLoading = false;
                      });
                      alertToast("$ex", Colors.red, Colors.white);
                      print("error with sed signup client request $ex");
                    }
                  } else {
                    alertToast(
                        "Please Provide All Data", Colors.red, Colors.white);
                  }
                }, 755, 71),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
