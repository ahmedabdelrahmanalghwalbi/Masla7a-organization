import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/user_status_parser.dart';
import '../../../models/top_worker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/status_badge.dart';
import '../../../utils/size_config.dart';
import '../../../utils/toggle_favourite.dart';
import '../../../utils/getServiceProviderProfile.dart';

class TopWorkerCards extends StatefulWidget {
  @override
  _TopWorkerCardsState createState() => _TopWorkerCardsState();
}

class _TopWorkerCardsState extends State<TopWorkerCards> {
  List<TopWorker> _topWorkers = [];
  var _isFavLoading = false;

  _getTopWorkers() async {
    var userPrefs = await SharedPreferences.getInstance();
    var currentToken = userPrefs.getString('token');

    var url = Uri.parse('https://masla7a.herokuapp.com/home/top-workers');
    var request = http.Request('GET', url);
    request.headers.addAll({'x-auth-token': '$currentToken'});

    var response = await request.send();

    final respStr = await response.stream.bytesToString();
    var resBody = json.decode(respStr);

    List<TopWorker> topWorkers = [];
    if (response.statusCode == 200) {
      resBody['serviceProviders'].forEach((worker) {
        topWorkers.add(TopWorker(
          id: worker['serviceProvider']['_id'],
          name: worker['serviceProvider']['name'],
          status: worker['serviceProvider']['availability'],
          gender: worker['serviceProvider']['gender'],
          profilePic: worker['serviceProvider']['profilePic'],
          serviceName: worker['serviceName'],
          rating: worker['averageRating'],
          isFav: worker['favourite'],
        ));
      });

      setState(() {
        _topWorkers = topWorkers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTopWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return _topWorkers.isEmpty
        ? Container(
            height: getProportionateScreenHeight(270),
            child: const Center(child: const CircularProgressIndicator()),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: const EdgeInsets.only(bottom: 10.0),
            constraints: BoxConstraints(
              maxHeight: getProportionateScreenHeight(270),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _topWorkers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    getServiceProviderProfile(context, _topWorkers[index].id);
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: getProportionateScreenWidth(210),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: getProportionateScreenHeight(200),
                                width: getProportionateScreenWidth(210),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        _topWorkers[index].profilePic),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 14,
                                child: Container(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(Icons.star_rate_rounded,
                                          color: Color(0xFFFFDF00)),
                                      Text(
                                        _topWorkers[index]
                                            .rating
                                            .toStringAsFixed(1),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        Row(
                                          children: [
                                            StatusBadge(
                                                status: statusParser(
                                                    _topWorkers[index].status)),
                                            const SizedBox(width: 4),
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    getProportionateScreenWidth(
                                                        130),
                                              ),
                                              child: Text(
                                                _topWorkers[index].name,
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                getProportionateScreenWidth(
                                                    140),
                                          ),
                                          child: Text(
                                            _topWorkers[index].serviceName,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: _isFavLoading
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 12),
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ))
                                        : IconButton(
                                            onPressed: () async {
                                              if (_topWorkers[index].isFav ==
                                                  true) {
                                                setState(() {
                                                  _isFavLoading = true;
                                                });
                                                await removeFavourite(
                                                    _topWorkers[index].id);
                                                await _getTopWorkers();
                                                setState(() {
                                                  _isFavLoading = false;
                                                });
                                              } else {
                                                setState(() {
                                                  _isFavLoading = true;
                                                });
                                                await addToFavourites(
                                                    _topWorkers[index].id);
                                                await _getTopWorkers();
                                                setState(() {
                                                  _isFavLoading = false;
                                                });
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.favorite_rounded),
                                            color: _topWorkers[index].isFav
                                                ? Colors.red
                                                : Colors.grey,
                                            iconSize: 30,
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
