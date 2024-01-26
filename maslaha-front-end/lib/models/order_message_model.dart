class OrderMessage {
  final bool isMe;
  final receiverId;
  final DateTime sentAt;
  final String service;
  final double price;
  final DateTime date;
  final DateTime startAt;
  final DateTime endAt;
  final String location;

  OrderMessage({
    required this.isMe,
    required this.receiverId,
    required this.sentAt,
    required this.service,
    required this.price,
    required this.date,
    required this.startAt,
    required this.endAt,
    required this.location,
  });
}
