import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../shared/constants.dart';
import '../../../models/chat_message_model.dart';

class OrderMessageBubble extends StatefulWidget {
  OrderMessageBubble({
    required this.isMe,
    required this.receiverId,
    required this.sentAt,
    required this.service,
    required this.price,
    required this.date,
    required this.startAt,
    required this.endAt,
    required this.location,
    required this.socket,
  });

  final bool isMe;
  final String receiverId;
  final DateTime sentAt;
  final String service;
  final double price;
  final DateTime date;
  final DateTime startAt;
  final DateTime endAt;
  final String location;
  final IO.Socket socket;

  @override
  _OrderMessageBubbleState createState() => _OrderMessageBubbleState();
}

class _OrderMessageBubbleState extends State<OrderMessageBubble> {
  late bool _orderStatus;

  @override
  void initState() {
    super.initState();
    _orderStatus = widget.isMe;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade300,
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          clipBehavior: Clip.none,
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Center(
                    child: Text(
                      'Service Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                buildServiceInfoField('Service', '${widget.service},'),
                buildServiceInfoField('Price', '${widget.price}EGP,'),
                buildServiceInfoField('Date of service',
                    '${intl.DateFormat.yMd().format(widget.date)},'),
                buildServiceInfoField('Start Time',
                    '${intl.DateFormat.jm().format(widget.startAt)},'),
                buildServiceInfoField('End Time',
                    '${intl.DateFormat.jm().format(widget.endAt)},'),
                buildServiceInfoField('Location', '${widget.location}.'),
                Visibility(
                  visible: !_orderStatus,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _orderStatus = true;
                              });
                              var prefs = await SharedPreferences.getInstance();
                              var token = prefs.getString('token');

                              widget.socket.connect();
                              widget.socket
                                  .emit('authenticate', {'token': token});
                              widget.socket
                                  .emit('decline', {'to': widget.receiverId});
                            },
                            style: TextButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              'Decline',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _orderStatus = true;
                              });
                              var prefs = await SharedPreferences.getInstance();
                              var token = prefs.getString('token');

                              widget.socket.connect();
                              widget.socket
                                  .emit('authenticate', {'token': token});
                              widget.socket.emit(
                                  'acceptance', {'to': widget.receiverId});
                            },
                            style: TextButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.green,
                            ),
                            child: Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              intl.DateFormat.jm().format(widget.sentAt),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
    // Bubble(
    //   alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
    //   margin: const BubbleEdges.symmetric(horizontal: 8, vertical: 3),
    //   color: widget.isMe ? Colors.blueGrey[400] : kPrimaryColor,
    //   nip: widget.isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
    //   child: Wrap(
    //     alignment: WrapAlignment.end,
    //     clipBehavior: Clip.none,
    //     spacing: 10,
    //     runSpacing: 10,
    //     crossAxisAlignment: WrapCrossAlignment.end,
    //     children: [
    //       Text(
    //         '''
    //         Service: ${widget.service},
    //         Price: '${widget.price} EGP.',
    //         Date of service: ${intl.DateFormat.yMd().format(widget.date)},
    //         Start Time: ${intl.DateFormat.jm().format(widget.startAt)},
    //         End Time: ${intl.DateFormat.jm().format(widget.endAt)},
    //         Location: ${widget.location}.
    //         ''',
    //         style: const TextStyle(
    //           color: Colors.white,
    //         ),
    //         textAlign: TextAlign.start,
    //         softWrap: true,
    //         overflow: TextOverflow.visible,
    //       ),
    //       Text(
    //         intl.DateFormat.jm().format(widget.sentAt),
    //         style: const TextStyle(
    //           color: Colors.white70,
    //           fontSize: 12,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget buildServiceInfoField(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
