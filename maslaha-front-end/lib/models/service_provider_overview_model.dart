class ServiceProviderOverview {
  final String id;
  final String name;
  final String profileImg;
  final String stauts;
  final double rating;
  final String serviceName;
  final num distanceAway;
  final num initialPrice;
  bool isFav;

  ServiceProviderOverview({
    required this.id,
    required this.name,
    required this.profileImg,
    required this.stauts,
    required this.rating,
    required this.serviceName,
    required this.distanceAway,
    required this.initialPrice,
    this.isFav = false,
  });
}
