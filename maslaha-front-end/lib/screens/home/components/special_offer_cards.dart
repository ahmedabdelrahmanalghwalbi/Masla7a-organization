import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maslaha/models/top_worker_model.dart';
import 'package:maslaha/shared/constants.dart';
import 'package:maslaha/utils/getServiceProviderProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../utils/size_config.dart';
import '../../../widgets/dialog_box.dart';

class SpecialOfferCards extends StatefulWidget {
  @override
  _SpecialOfferCardsState createState() => _SpecialOfferCardsState();
}

class _SpecialOfferCardsState extends State<SpecialOfferCards> {
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

  var titles = ['Free Month of BabySitting.', '50% off, limited time.'];

  var desc = [
    'Now get a free whole month of babysitting if you hired me for half that time! what a great deal no? contact me now.',
    'Gift your beloved ones with wounderful handmade paintings, what you waiting for? draw a big smile on there faces now and with 50% off for limited time. Hurry up!'
  ];

  var covers = [
    'https://www.heart2heartcpr.com/wp-content/uploads/2018/08/babysitting_course.jpg',
    'https://www.thisiscolossal.com/wp-content/uploads/2020/07/wray-3-687x916@2x.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      height: getProportionateScreenHeight(165),
      child: _topWorkers.isEmpty
          ? CircularProgressIndicator(color: kPrimaryColor)
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogBox(
                          tag: 'assets/icons/price-tag.svg',
                          title: titles[index],
                          description: desc[index],
                          actionButtonTitle: 'Vist profile',
                          actionButtonFunction: () => getServiceProviderProfile(
                              context, _topWorkers[index].id),
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: Colors.white,
                    child: Stack(children: [
                      Container(
                        width: getProportionateScreenWidth(210),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(covers[index]),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      Container(
                        width: getProportionateScreenWidth(210),
                        decoration: BoxDecoration(
                          color: Colors.black38.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    getServiceProviderProfile(
                                        context, _topWorkers[index].id);
                                  },
                                  child: CircleAvatar(
                                    radius: 27.0,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipOval(
                                      child: Image.network(
                                        _topWorkers[index].profilePic,
                                        width: 50.0,
                                        height: 50.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Text(
                                    _topWorkers[index].serviceName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  Container(
                                    width: getProportionateScreenWidth(200),
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      titles[index],
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
