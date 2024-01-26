import 'dart:convert';

import 'package:flutter/material.dart';
import '../authenticaton/auth_components/alertToast.dart';
import 'package:http/http.dart' as http;
import 'components/complaint_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintBox extends StatefulWidget {
  static const routeName = '/complaint-box';

  @override
  _ComplaintBoxState createState() => _ComplaintBoxState();
}

class _ComplaintBoxState extends State<ComplaintBox> {
  String userName = "";
  String complaintType = "";
  String description = "";
  bool isBlue1 = false;
  bool isBlue2 = false;
  bool isBlue3 = false;
  bool isBlue4 = false;
  bool isBlue5 = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Color(0xff4378E3),
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Complaints",
          style:
              TextStyle(color: Color(0xff4378E3), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
//          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Service Provider",
                style: TextStyle(
                    color: Color(0xff4378E3),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 15),
                child: TextFormField(
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffE4DCDC)),
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Color(0xffA0BBF0),
                    ),
                  ),
                ),
              ),
              Text(
                "Complaint Type",
                style: TextStyle(
                    color: Color(0xff4378E3),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            complaintType = "Bad Behaviuor";
                            isBlue1 = true;
                            isBlue2 = false;
                            isBlue3 = false;
                            isBlue4 = false;
                            isBlue5 = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: isBlue1 ? Color(0xff4378E3) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Bad Behaviuor",
                              style: TextStyle(
                                  color: isBlue1
                                      ? Colors.white
                                      : Color(0xff4378E3)),
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            complaintType = "High Prices";
                            isBlue1 = false;
                            isBlue2 = true;
                            isBlue3 = false;
                            isBlue4 = false;
                            isBlue5 = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: isBlue2 ? Color(0xff4378E3) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "High Prices",
                              style: TextStyle(
                                  color: isBlue2
                                      ? Colors.white
                                      : Color(0xff4378E3)),
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            complaintType = "Delay";
                            isBlue1 = false;
                            isBlue2 = false;
                            isBlue3 = true;
                            isBlue4 = false;
                            isBlue5 = false;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: isBlue3 ? Color(0xff4378E3) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Delay",
                              style: TextStyle(
                                  color: isBlue3
                                      ? Colors.white
                                      : Color(0xff4378E3)),
                            ),
                          ),
                        ),
                      )),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                complaintType = "Caused Damage";
                                isBlue1 = false;
                                isBlue2 = false;
                                isBlue3 = false;
                                isBlue4 = true;
                                isBlue5 = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: isBlue4
                                      ? Color(0xff4378E3)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey)),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "Caused Damage",
                                  style: TextStyle(
                                      color: isBlue4
                                          ? Colors.white
                                          : Color(0xff4378E3)),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            complaintType = "Others";
                            isBlue1 = false;
                            isBlue2 = false;
                            isBlue3 = false;
                            isBlue4 = false;
                            isBlue5 = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: isBlue5 ? Color(0xff4378E3) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Others",
                              style: TextStyle(
                                  color: isBlue5
                                      ? Colors.white
                                      : Color(0xff4378E3)),
                            ),
                          ),
                        ),
                      )),
                      Expanded(child: Container()),
                    ],
                  )),
              Text(
                "Description",
                style: TextStyle(
                    color: Color(0xff4378E3),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
//                        color: Color(0xffE4DCDC),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                child: TextFormField(
                  maxLines: null,
                  onChanged: (val) {
                    setState(() {
                      description = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
//                        border: OutlineInputBorder(
//                            borderSide:BorderSide(color: Color(0xffE4DCDC)),borderRadius: BorderRadius.circular(15)),
                    hintText: "Enter your thoughts here ... ",
                  ),
                ),
              ),
              // raise the complaints button
              GestureDetector(
                onTap: () async {
                  if (userName != "" &&
                      complaintType != "" &&
                      description != "") {
                    setState(() {
                      isLoading = true;
                    });
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    http.Response response = await http.post(
                      Uri.parse('https://masla7a.herokuapp.com/home/complaint'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        'x-auth-token': pref.getString("token").toString()
                      },
                      body: jsonEncode(<String, String>{
                        'userName': userName,
                        'complaintType': complaintType,
                        'description': description
                      }),
                    );
                    if (response.statusCode == 200) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ComplaintDialog(
                            tag: 'assets/images/auth_images/done.png',
                            title: "",
                            description:
                                "Your complaint has been raised successfully.",
                            actionButtonTitle: 'Vist profile',
                            // TODO: go to servicer provider profile
                            actionButtonFunction: () =>
                                print('Navigate to profile'),
                          );
                        },
                      );
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      alertToast(
                          response.body, Color(0xff4378E3), Colors.white);
                    }
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    alertToast("Please Provide All Data ..!", Color(0xff4378E3),
                        Colors.white);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      color: Color(0xff447AE6),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Raise a Complaint",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
