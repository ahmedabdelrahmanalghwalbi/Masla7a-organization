enum MessageType { Text, Picture }

class ChatMessage {
  final bool isMyMsg;
  final String? content;
  final String? attachment;
  final String sentAt;
  final MessageType messageType;

  ChatMessage({
    required this.isMyMsg,
    required this.messageType,
    this.content,
    this.attachment,
    required this.sentAt,
  });
}
