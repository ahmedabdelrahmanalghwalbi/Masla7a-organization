import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maslaha/screens/authenticaton/auth_components/alertToast.dart';
import 'package:maslaha/screens/order/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CancelledOrderDialog extends StatefulWidget {
  final String tag;
  final String title;
  final String description;
  final String actionButtonTitle;
  final Function actionButtonFunction;
  var orderId;

   CancelledOrderDialog({
    required this.orderId,
    required this.tag,
    required this.title,
    required this.description,
    required this.actionButtonTitle,
    required this.actionButtonFunction,
  });

  @override
  _CancelledOrderDialogState createState() => _CancelledOrderDialogState();
}

class _CancelledOrderDialogState extends State<CancelledOrderDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _slideAnimation = Tween(begin: Offset(0.0, 2.0), end: Offset(0.0, 0.0))
        .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: Colors.blue),
              child: Image.asset(
                widget.tag,
                height: 80.0,
                width: 80.0,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
        content: Text(
          widget.description,
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffEDF1F7)),
                  child: TextButton(
                    onPressed: () {
                      _controller.reverse();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffEF1212)),
                  child: TextButton(
                    onPressed: () async{
                      SharedPreferences _pref = await SharedPreferences.getInstance();
                      final response = await http.put(
                          Uri.parse('https://masla7a.herokuapp.com/orders/cancele-order/${widget.orderId}'),
                          headers: {"x-auth-token": _pref.getString("token").toString()});
                      if (response.statusCode == 200) {
                        print(
                            "the order canceled successfully ${jsonDecode(response.body)}");
//                        fetchPendingOrders();
                        _controller.reverse();
                        return jsonDecode(response.body);
                      } else {
                        alertToast(response.body.toString(), Colors.blue, Colors.white);
                        throw Exception('failed to canceled this order');
                      }
                    },
                    child: Text(
                      'Cancel Order',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
//          TextButton(
//            onPressed: () {
//              widget.actionButtonFunction();
//            },
//            child: Text(
//              widget.actionButtonTitle,
//            ),
//          ),
        ],
      ),
    );
  }
}
