import 'package:flutter/material.dart';
import '../../../utils/user_status_parser.dart';

import '../../../utils/size_config.dart';
import '../../../widgets/profile_image_container.dart';
import '../chat_screen.dart';
import '../../../widgets/status_badge.dart';

class ConversationCard extends StatelessWidget {
  final String convId;
  final String myRole;
  final String receiverId;
  final String receiverName;
  final String receiverProfilePic;
  final String receiverStatus;
  final String lastMessage;
  final String lastMessageTime;
  final Function(DismissDirection)? onDismissed;

  ConversationCard({
    required this.convId,
    required this.myRole,
    required this.receiverId,
    required this.receiverName,
    required this.receiverProfilePic,
    required this.receiverStatus,
    required this.lastMessage,
    required this.lastMessageTime,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('${DateTime.now()}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  convID: convId,
                  myRole: myRole,
                  receiverID: receiverId,
                  receiverName: receiverName,
                  receiverProfilePic: receiverProfilePic,
                  receiverStatus: receiverStatus,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                StatusBadge.overlayed(
                  right: 10,
                  bottom: 7,
                  borderSize: 3,
                  status: statusParser(receiverStatus),
                  child: ProfileImageContainer(
                    profileImg: receiverProfilePic,
                    width: getProportionateScreenWidth(55),
                    height: getProportionateScreenHeight(80),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              receiverName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(child: Text('$lastMessageTime')),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(4)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              lastMessage,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                          // Flexible(
                          //   child: const CircleAvatar(
                          //     radius: 10,
                          //     child: FittedBox(
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(4),
                          //         child: Text(
                          //           '1',
                          //           style: const TextStyle(color: Colors.white),
                          //         ),
                          //       ),
                          //     ),
                          //     backgroundColor: Colors.red,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
