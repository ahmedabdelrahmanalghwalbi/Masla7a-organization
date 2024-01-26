import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'auth_page_transition/sign_up_as_worker3.dart';
import '../../shared/constants.dart';
import '../../utils/size_config.dart';
import 'auth_components/alertToast.dart';
import 'auth_components/arrow_back_button.dart';
import 'auth_components/auth_button.dart';
import 'auth_components/auth_title.dart';
import 'auth_page_transition/slid_right_transition.dart';

class SignUpAsWorker2 extends StatefulWidget {
  late String gender;
  late File? photo;
  late String email;
  late String password;
  late String name;
  SignUpAsWorker2(
      {required this.gender,
      required this.email,
      required this.password,
      required this.name,
      required this.photo});
  @override
  _SignUpAsWorker2State createState() => _SignUpAsWorker2State();
}

class _SignUpAsWorker2State extends State<SignUpAsWorker2> {
  String birthDate = "";
  String phone = "";
  String nationalID = '';
  String address = '';
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
                              minTime: DateTime(1961, 1, 1),
                              maxTime: DateTime(2003, 12, 30), onChanged: (date) {
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
                              locale: LocaleType.en);
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
                      keyboardType: TextInputType.number,
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
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {
                        setState(() {
                          phone = val;
                        });
                      },
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
                authButton("Next", () async {
                  if (birthDate != "" &&
                      nationalID != "" &&
                      phone != "" &&
                      address != "") {
                      if(phone.length==11){
                        if(nationalID.length==14){
                          Navigator.of(context).push(SlidRight(
                              page: SignUpAsWorker3(
                                gender: widget.gender,
                                name: widget.name,
                                email: widget.email,
                                password: widget.password,
                                image: widget.photo,
                                address: address,
                                birthDate: birthDate,
                                nationalID: nationalID,
                                phone: phone,
                              )));
                        }else{
                          alertToast("Please Provide Valid National Id", Colors.red, Colors.white);
                        }
                      }else{
                        alertToast("Please Provide Valid Phone", Colors.red, Colors.white);
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
