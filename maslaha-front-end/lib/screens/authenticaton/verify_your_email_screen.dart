import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../home/home_screen.dart';
import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_components/alertToast.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_components/auth_title.dart';
import 'auth_page_transition/slid_right_transition.dart';

class VerifyYourEmailScreen extends StatefulWidget {
  late String gender;
  late File? image;
  late String email;
  late String password;
  late String name;
  late String birthDate;
  late String phone;
  late String nationalID;
  late String address;
  late String category;
  late String serviceName;
  late String initialPrice;
  late String description;
  VerifyYourEmailScreen(
      {required this.category,
      required this.serviceName,
      required this.initialPrice,
      required this.description,
      required this.address,
      required this.phone,
      required this.nationalID,
      required this.birthDate,
      required this.email,
      required this.name,
      required this.gender,
      required this.password,
      required this.image});
  static String routeName = "/VerifyYourEmailScreen";
  @override
  _VerifyYourEmailScreenState createState() => _VerifyYourEmailScreenState();
}

class _VerifyYourEmailScreenState extends State<VerifyYourEmailScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  bool isLoading = false;
  String code = '';
  var authState = '';
  String verificationID = '';
  var auth = FirebaseAuth.instance;
  bool otpDone = false;

  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border: Border.all(color: kAuthMainColor),
        borderRadius: BorderRadius.circular(15));
  }

  // OTP
  verifyPhone(String phone) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 40),
        verificationCompleted: (AuthCredential authCredential) {},
        verificationFailed: (authException) {
          alertToast("Problem with Sending the Code", Colors.red, Colors.white);
        },
        codeSent: (String id, [int? forceResent]) {
          verificationID = id;
          authState = "login success";
        },
        codeAutoRetrievalTimeout: (id) {
          verificationID = id;
        });
  }

  verifyOTP(String otp) async {
    var credential = await auth.signInWithCredential(
      PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otp),
    );
    if (credential != null) {
      setState(() {
        isLoading = true;
      });
      try {
        var url = Uri.parse('https://masla7a.herokuapp.com/accounts/sign-up');
        var request = http.MultipartRequest('POST', url);
        final file =
            await http.MultipartFile.fromPath("profilePic", widget.image!.path);
        request.files.add(file);
        request.fields["name"] = widget.name;
        request.fields["email"] = widget.email;
        request.fields["password"] = widget.password;
//                    request.fields["confirm_password"]=widget.password;
        request.fields["birthDate"] = widget.birthDate;
        request.fields["nationalID"] = widget.nationalID;
        request.fields["phone_number"] = widget.phone;
        request.fields["gender"] = widget.gender;
        request.fields["userName"] = widget.name;
        request.fields["role"] = "serviceProvider";
        request.fields["category"] = widget.category;
        request.fields["serviceName"] = widget.serviceName;
        //3 Shaaker El Gendi St.- El Sharabia - Cairo - Egypt
        request.fields["address"] = widget.address;
        request.fields["description"] = widget.description;
        request.fields["servicePrice"] = widget.initialPrice;
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        var result = json.decode(respStr);
        print(respStr);
        print("this is the token ${result["token"]}");
        setState(() {
          isLoading = false;
        });
        if (response.statusCode == 200) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("token", result["token"]);
          pref.setBool("isAuth", true);
          Navigator.of(context).push(SlidRight(page: HomeScreen()));
        }
      } catch (ex) {
        setState(() {
          isLoading = false;
        });
        alertToast("$ex", Colors.red, Colors.white);
        print("error with sed signup client request $ex");
      }
    } else {
      alertToast("Code Not Match..!", Colors.red, Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    verifyPhone("+2" + widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAuthMainColor,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                  top: getProportionateScreenHeight(110),
                  left: getProportionateScreenWidth(55),
                  child: Container(
                    width: getProportionateScreenWidth(284),
                    height: getProportionateScreenHeight(165),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/auth_images/Authentication-pana@1X.png"),
                          fit: BoxFit.contain),
                    ),
                  )),
              authTitle("Verify your e-mail", 368, 96),
              Positioned(
                top: getProportionateScreenHeight(417),
                left: getProportionateScreenWidth(52),
                child: Container(
                  width: getProportionateScreenWidth(269),
                  height: getProportionateScreenHeight(48),
                  child: Center(
                    child: Text(
                      "Please enter the 4 digit code sent to name@example.com",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        color: kTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              //PIN code
              Positioned(
                top: getProportionateScreenHeight(484),
                left: getProportionateScreenWidth(40),
                right: getProportionateScreenWidth(40),
                child: PinPut(
                  fieldsCount: 6,
//                  onChanged: (val){
//                    setState(() {
//                      code=val;
//                    });
//                  },
                  onSubmit: (val) {
                    setState(() {
                      code = val;
                    });
                    print(code);
                  },
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Color(0xFF979797),
                    ),
                  ),
                ),
              ),
              authButton(isLoading ? "Loading ..." : "SignUp", () async {
                if (code != "") {
//                  verifyOTP(code);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                } else {
                  alertToast("Please Provide The Sending Code", Colors.red,
                      Colors.white);
                }
              }, 755, 71),
              //Timer
              Positioned(
                top: getProportionateScreenHeight(570),
                left: getProportionateScreenWidth(140),
                child: Container(
                  width: getProportionateScreenWidth(100),
                  height: getProportionateScreenHeight(35),
                  child: Center(
                    child: TweenAnimationBuilder<Duration>(
                        duration: Duration(minutes: 2),
                        tween: Tween(
                            begin: Duration(minutes: 2), end: Duration.zero),
                        onEnd: () {
                          Navigator.pop(context);
                          print(code);
                        },
                        builder: (BuildContext context, Duration value,
                            Widget? child) {
                          final minutes = value.inMinutes;
                          final seconds = value.inSeconds % 60;
                          return Text('$minutes:$seconds',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff4C4C4C), fontSize: 31));
                        }),
                  ),
                ),
              ),
              //Resend Code Button
              Positioned(
                top: getProportionateScreenHeight(733),
                left: getProportionateScreenWidth(146),
                child: GestureDetector(
                  onTap: () {
                    verifyPhone("+2" + widget.phone);
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: kAuthMainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
