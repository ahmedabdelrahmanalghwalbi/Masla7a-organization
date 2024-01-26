class ConversationTile {
  final String convId;
  final String myRole;
  final String receiverId;
  final String receiverName;
  final String receiverProfilePic;
  final String receiverStatus;
  final String lastMessage;
  final String lastMessageTime;

  ConversationTile({
    required this.convId,
    required this.myRole,
    required this.receiverId,
    required this.receiverName,
    required this.receiverProfilePic,
    required this.receiverStatus,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
