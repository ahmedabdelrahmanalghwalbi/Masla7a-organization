import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maslaha/screens/authenticaton/auth_components/alertToast.dart';
import 'package:maslaha/screens/order/component/cancel_order_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import 'component/order_dialog.dart';

class Order extends StatefulWidget {
  static const routeName = '/orders';
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List cancelledOrders=[];
  List pendingOrders=[];
  List completeOrders=[];
  bool isLoading=false;
  //cancel orders
  fetchCancelledOrders() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('https://masla7a.herokuapp.com/orders/?status=canceled'),
        headers: {"x-auth-token": _pref.getString("token").toString()});
    if (response.statusCode == 200) {
      print(
          "this is the jsoooooooooon ${jsonDecode(response.body)["orders"][0]}");
      setState(() {
        cancelledOrders = jsonDecode(response.body)["orders"];
      });
      return jsonDecode(response.body);
    } else {
      alertToast(response.body.toString(), Colors.blue, Colors.white);
      throw Exception('Failed to load album');
    }
  }
  //pending orders
  fetchPendingOrders() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('https://masla7a.herokuapp.com/orders/?status=pending'),
        headers: {"x-auth-token": _pref.getString("token").toString()});
    if (response.statusCode == 200) {
      print(
          "this is the jsoooooooooon ${jsonDecode(response.body)["orders"][0]}");
      setState(() {
        pendingOrders = jsonDecode(response.body)["orders"];
      });
      return jsonDecode(response.body);
    } else {
      alertToast(response.body.toString(), Colors.blue, Colors.white);
      throw Exception('Failed to load album');
    }
  }
  //complete orders
  fetchCompleteOrders() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('https://masla7a.herokuapp.com/orders/?status=completed'),
        headers: {"x-auth-token": _pref.getString("token").toString()});
    if (response.statusCode == 200) {
      print(
          "this is the jsoooooooooon ${jsonDecode(response.body)["orders"][0]}");
      setState(() {
        completeOrders = jsonDecode(response.body)["orders"];
      });
      return jsonDecode(response.body);
    } else {
      alertToast(response.body.toString(), Colors.blue, Colors.white);
      throw Exception('Failed to load album');
    }
  }
  ////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCancelledOrders();
    fetchCompleteOrders();
    fetchPendingOrders();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffF6F6F6),
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
            "Orders",
            style: TextStyle(
                color: Color(0xff4378E3), fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Pending",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Complete",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Cancelled",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //pending orders
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 110),
                height: MediaQuery.of(context).size.height,
                child:pendingOrders.length==0?Center(
                  child: Text("No Pending Orders yet ..!",style: TextStyle(
                    color: Colors.grey
                  ),),
                ):ListView(
                  scrollDirection: Axis.vertical,
                  children: pendingOrders.map((order){
                    final DateTime date =DateTime.parse(order["orderDate"]);
                    final DateFormat formatter = DateFormat('yyyy-MM-dd hh-mm');
                    final String formatted = formatter.format(date);
                    print(formatted);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return OrderDialog(
                                  category: order["serviceName"],
                                  status: order["status"],
                                  orderName: formatted,
                                  serviceProvider: order["customerId"]["name"],
                                  price: order["price"],
                                );
                                },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height / 3.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                //First row
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 15,right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order["serviceId"]["serviceName"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        order["status"],
                                        style: TextStyle(
                                          color: Color(0xffF2B900),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //second row
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, left: 15, top: 15, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Assigned",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            order["customerId"]["name"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Schedule",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            formatted.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap:()async{
                                        SharedPreferences _pref = await SharedPreferences.getInstance();
                                         http.put(
                                            Uri.parse('https://masla7a.herokuapp.com/orders/cancele-order/${order["_id"]}'),
                                            headers: {"x-auth-token": _pref.getString("token").toString()}).then((value) {
                                          print(
                                              "the order canceled successfully");
                                          fetchPendingOrders();
                                          fetchCancelledOrders();
                                          fetchCompleteOrders();
                                          alertToast("Order Canceled Successfully", Colors.red, Colors.white);
                                        }).catchError((ex){
                                          alertToast(ex.toString(), Colors.blue, Colors.white);
                                          throw Exception('failed to canceled this order');
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.red),
                                        child: Center(
                                          child: Text(
                                            "Cancel Order",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        SharedPreferences _pref = await SharedPreferences.getInstance();
                                         http.put(
                                            Uri.parse('https://masla7a.herokuapp.com/orders/complete-order/${order["_id"]}'),
                                            headers: {"x-auth-token": _pref.getString("token").toString()}).then((value){
                                          print(
                                              "the order completed successfully");
                                          alertToast("Order Completed Sucessfully", Colors.green, Colors.white);
                                          fetchPendingOrders();
                                          fetchCancelledOrders();
                                          fetchCompleteOrders();
                                        }).catchError((ex){
                                          alertToast(ex.toString(), Colors.blue, Colors.white);
                                          throw Exception('failed to completed this order this order${ex.toString()}');
                                        });

//                                      showDialog(
//                                        context: context,
//                                        builder: (context) {
//                                          return OrderDialog(
//                                           category: order["serviceName"],
//                                            status: order["status"],
//                                            orderName: formatted,
//                                            serviceProvider: order["customerId"]["name"],
//                                            price: order["price"],
//                                          );
//                                        },
//                                      );
//                                      showDialog(
//                                        context: context,
//                                        builder: (context) {
//                                          return CancelledOrderDialog(
//                                            orderId: order["_id"],
//                                            tag: 'assets/images/auth_images/done.png',
//                                            title: "Are you Sure Want To Cancel Your Order ?",
//                                            description:
//                                            "If you cancelled your order you won't be able to undo your cancellation.",
//                                            actionButtonTitle: 'Vist profile',
//                                            // TODO: go to servicer provider profile
//                                            actionButtonFunction: () =>
//                                                print('Navigate to profile'),
//                                          );
//                                        },
//                                      );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Color(0xff69D362),
                                          border: Border.all(color:Color(0xff69D362))
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Complete",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList()
                ),
              ),
            ),
            ////////////////////////////////////////////////////////
            //complete orders
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 110),
                height: MediaQuery.of(context).size.height,
                child:completeOrders.length==0?Center(
                  child:  Text("No Complete Orders yet ..!",style: TextStyle(
                      color: Colors.grey
                  ),),
                ):ListView(
                    scrollDirection: Axis.vertical,
                    children: completeOrders.map((order){
                      final DateTime date =DateTime.parse(order["orderDate"]);
                      final DateFormat formatter = DateFormat('yyyy-MM-dd hh-mm');
                      final String formatted = formatter.format(date);
                      print(formatted);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height / 3.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                //First row
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 15,right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order["serviceId"]["serviceName"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        order["status"],
                                        style: TextStyle(
                                          color: Color(0xff69D362),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //second row
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, left: 15, top: 15, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Assigned",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            order["customerId"]["name"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Schedule",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            formatted.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return OrderDialog(
                                              category: order["serviceName"],
                                              status: order["status"],
                                              orderName: formatted,
                                              serviceProvider: order["customerId"]["name"],
                                              price: order["price"],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.blue)
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Details",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()
                ),
              ),
            ),
            ////////////////////////////////////////////////////////
            //cancelled orders
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 110),
                height: MediaQuery.of(context).size.height,
                child:cancelledOrders.length==0?Center(
                  child:  Text("No Cancelled Orders yet ..!",style: TextStyle(
                      color: Colors.grey
                  ),),
                ):ListView(
                    scrollDirection: Axis.vertical,
                    children: cancelledOrders.map((order){
                      final DateTime date =DateTime.parse(order["orderDate"]);
                      final DateFormat formatter = DateFormat('yyyy-MM-dd hh-mm');
                      final String formatted = formatter.format(date);
                      print(formatted);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height / 3.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                //First row
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,bottom: 8,left: 15,right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order["serviceId"]["serviceName"],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        order["status"],
                                        style: TextStyle(
                                          color: Color(0xffEF1212),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //second row
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15.0, left: 15, top: 15, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Assigned",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            order["customerId"]["name"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Schedule",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            formatted.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return OrderDialog(
                                              category: order["serviceName"],
                                              status: order["status"],
                                              orderName: formatted,
                                              serviceProvider: order["customerId"]["name"],
                                              price: order["price"],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        padding: EdgeInsets.all(10),
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.blue)
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Details",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
