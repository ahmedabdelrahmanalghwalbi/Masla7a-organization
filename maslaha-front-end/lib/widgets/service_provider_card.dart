import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maslaha/utils/getServiceProviderProfile.dart';
import '../shared/constants.dart';
import '../utils/user_status_parser.dart';
import '../utils/size_config.dart';
import 'profile_image_container.dart';
import 'status_badge.dart';

class ServiceProviderCard extends StatelessWidget {
  ServiceProviderCard({
    required this.id,
    required this.profilePicUrl,
    required this.userName,
    required this.service,
    required this.distanceAway,
    required this.startingPrice,
    required this.status,
    required this.rating,
    required this.isFav,
    this.onHeartPressed,
    this.isLoading = false,
  });

  final String id;
  final String profilePicUrl;
  final String userName;
  final String service;
  final double distanceAway;
  final double startingPrice;
  final String status;
  final double rating;
  final bool isFav;
  final Function()? onHeartPressed;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          getServiceProviderProfile(context, id);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 10),
          child: Row(
            children: [
              ProfileImageContainer(
                profileImg: profilePicUrl,
                width: getProportionateScreenWidth(65),
                height: getProportionateScreenHeight(90),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(
                          status: statusParser(status),
                          size: 5,
                          withText: true,
                          textColor: Colors.black54,
                          textSize: 13,
                        ),
                        RatingBarIndicator(
                          rating: rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      service,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    Text(
                      '${distanceAway}km away from your location.',
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            'Starts from $startingPrice L.E.',
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 15),
                          ),
                        ),
                        Flexible(
                          child: isLoading
                              ? SizedBox.fromSize(
                                  size: const Size.fromRadius(15),
                                  child: const CircularProgressIndicator(
                                    color: kPrimaryColor,
                                    strokeWidth: 3,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: onHeartPressed,
                                  child: Icon(
                                    Icons.favorite_sharp,
                                    color: isFav ? Colors.red : Colors.grey,
                                    size: 30,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
