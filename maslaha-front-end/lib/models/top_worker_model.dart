class TopWorker {
  final String id;
  final String name;
  final String profilePic;
  final String gender;
  final String serviceName;
  final num rating;
  String status;
  bool isFav;

  TopWorker({
    required this.id,
    required this.name,
    required this.gender,
    required this.profilePic,
    required this.serviceName,
    required this.rating,
    required this.status,
    this.isFav = false,
  });
}
