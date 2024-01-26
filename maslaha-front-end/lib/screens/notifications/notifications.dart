import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../authenticaton/auth_components/alertToast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  static const routeName = '/notifications';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List data = [];

  fetchNotification() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('https://masla7a.herokuapp.com/notifications/'),
        headers: {"x-auth-token": _pref.getString("token").toString()});
    if (response.statusCode == 200) {
      print(
          "this is the jsoooooooooon ${jsonDecode(response.body)["notifications"][0]}");
      setState(() {
        data = jsonDecode(response.body)["notifications"];
      });
      return jsonDecode(response.body);
    } else {
      alertToast(response.body.toString(), Colors.blue, Colors.white);
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotification();
  }

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
          "Notifications",
          style:
              TextStyle(color: Color(0xff4378E3), fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            color: Color(0xffF6F6F6)),
        child: data.length != 0
            ? ListView(
                scrollDirection: Axis.vertical,
                children: data.map((notification) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Dismissible(
                      key: Key(notification["_id"].toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await http.delete(
                          Uri.parse(
                              'https://masla7a.herokuapp.com/notifications/delete-notification/${notification["_id"]}'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            "x-auth-token":
                                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGU1ZTVhNjdkYTZiZTlmNzA3NWE0ZDUiLCJlbWFpbCI6ImFyd2FAZ21haWwuY29tIiwidXNlck5hbWUiOiJhcndhMTIzNCIsInJvbGUiOiJzZXJ2aWNlUHJvdmlkZXIiLCJnb3RBZGRyZXNzIjp0cnVlLCJpYXQiOjE2MjY2MjcxNzd9.qFGdYLWHmHUixDZXB8kGxGaMyFZZ19ayN7QZAh3FKwc"
                          },
                        );
                      },
                      background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Spacer(),
                            Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.white,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 88,
                                child: AspectRatio(
                                  aspectRatio: 0.88,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F6F9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Image.network(
                                        notification["senderUser"]
                                            ["profilePic"]),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification["title"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width /
                                          1.7,
                                      child: Text(
                                        notification["body"],
                                        style: TextStyle(color: Colors.grey),
                                      )),
//                              Text()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList())
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
      ),
    );
  }
}
