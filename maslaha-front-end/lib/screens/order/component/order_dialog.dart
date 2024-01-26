import 'package:flutter/material.dart';

class OrderDialog extends StatefulWidget {
  final String orderName;
  final String category;
  final String serviceProvider;
  var price;
  final String status;

   OrderDialog({
    required this.category,
     this.price,
    required this.status,
    required this.orderName,
    required this.serviceProvider,
  });

  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog>
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
        title: Center(
          child: Text("Order Details",style: TextStyle(
              color: Color(0xff4378E3),
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
        ),
        content: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Order Category : ${widget.category}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Customer : ${widget.serviceProvider}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Order Price : ${widget.price.toString()}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Order Status : ${widget.status}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Ordered Time : ${widget.orderName}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        actions: [
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: TextButton(
                onPressed: () {
                  _controller.reverse();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
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
