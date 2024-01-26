import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../shared/constants.dart';
import '../../../models/chat_message_model.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble(
    this.isMe,
    this.content,
    this.sentAt, {
    this.key,
  });

  final Key? key;
  final bool isMe;
  final dynamic content;
  final DateTime sentAt;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Bubble(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const BubbleEdges.symmetric(horizontal: 8, vertical: 3),
      color: widget.isMe ? Colors.blueGrey[400] : kPrimaryColor,
      nip: widget.isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
      child: Wrap(
        alignment: WrapAlignment.end,
        clipBehavior: Clip.none,
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(
            widget.content,
            style: const TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          Text(
            intl.DateFormat.jm().format(widget.sentAt),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
