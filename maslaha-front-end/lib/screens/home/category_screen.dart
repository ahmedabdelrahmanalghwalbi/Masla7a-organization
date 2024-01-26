import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/service_provider_overview_model.dart';
import '../../utils/toggle_favourite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/service_provider_card.dart';

class CategoryScreen extends StatefulWidget {
  final String catID;

  CategoryScreen({required this.catID});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<ServiceProviderOverview> _categorySPs = [];
  var _isFavLoading = false;

  _getCategorySPs() async {
    var userPrefs = await SharedPreferences.getInstance();
    var currentToken = userPrefs.getString('token');

    var url =
        Uri.parse('https://masla7a.herokuapp.com/categories/${widget.catID}');
    var request = http.Request('GET', url);
    request.headers.addAll({'x-auth-token': '$currentToken'});
    var response = await request.send();

    final respStr = await response.stream.bytesToString();
    var resBody = json.decode(respStr);
    print(resBody);

    List<ServiceProviderOverview> categorySPs = [];
    if (response.statusCode == 200) {
      resBody['serviceProviders'].forEach((sp) {
        categorySPs.add(ServiceProviderOverview(
          id: sp['_id'],
          name: sp['name'],
          profileImg: sp['profilePic'],
          stauts: sp['availability'],
          rating: sp['service']['averageRating'].toDouble(),
          serviceName: sp['service']['serviceName'],
          distanceAway: double.parse(sp['distance'].toStringAsFixed(1)),
          initialPrice: sp['service']['servicePrice'].toDouble(),
          isFav: sp['favourite'],
        ));
      });
    }

    setState(() {
      _categorySPs = categorySPs;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategorySPs();
  }

  @override
  Widget build(BuildContext context) {
    return _categorySPs.isEmpty
        ? const Center(
            child: const CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    '${_categorySPs.length} Service providers.',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: _categorySPs.length,
                  itemBuilder: (context, index) {
                    return ServiceProviderCard(
                      id: _categorySPs[index].id,
                      profilePicUrl: _categorySPs[index].profileImg,
                      status: _categorySPs[index].stauts,
                      userName: _categorySPs[index].name,
                      rating: _categorySPs[index].rating,
                      service: _categorySPs[index].serviceName,
                      distanceAway: double.parse(
                          _categorySPs[index].distanceAway.toStringAsFixed(1)),
                      startingPrice: _categorySPs[index].initialPrice as double,
                      isFav: _categorySPs[index].isFav,
                      isLoading: _isFavLoading,
                      onHeartPressed: () async {
                        if (_categorySPs[index].isFav == true) {
                          setState(() {
                            _isFavLoading = true;
                          });
                          await removeFavourite(_categorySPs[index].id);
                          await _getCategorySPs();
                          setState(() {
                            _isFavLoading = false;
                          });
                        } else {
                          setState(() {
                            _isFavLoading = true;
                          });
                          await addToFavourites(_categorySPs[index].id);
                          await _getCategorySPs();
                          setState(() {
                            _isFavLoading = false;
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}
