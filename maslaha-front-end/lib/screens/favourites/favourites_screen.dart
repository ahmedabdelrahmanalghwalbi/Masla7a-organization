import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/service_provider_overview_model.dart';
import '../../shared/constants.dart';
import '../../utils/toggle_favourite.dart';
import '../../widgets/service_provider_card.dart';

class FavouritesScreen extends StatefulWidget {
  static const routeName = '/favourites';

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  var _favourties = [];
  var _loading = false;

  _getUserFavourites() async {
    setState(() {
      _loading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    var currentToken = prefs.getString('token');
    print('token: $currentToken');

    var url = Uri.parse('https://masla7a.herokuapp.com/favourites/');
    var request = http.Request('GET', url);
    request.headers.addAll({'x-auth-token': '$currentToken'});
    var response = await request.send();

    final respStr = await response.stream.bytesToString();
    var resBody = await json.decode(respStr);
    print(resBody);

    List<ServiceProviderOverview> favourites = [];
    if (response.statusCode == 200 && resBody['count'] != 0) {
      resBody['favourites'].forEach((fav) {
        favourites.add(
          ServiceProviderOverview(
            id: fav['serviceProvider']['_id'],
            name: fav['serviceProvider']['name'],
            profileImg: fav['serviceProvider']['profilePic'],
            stauts: fav['serviceProvider']['availability'],
            distanceAway: fav['distance'],
            rating: fav['service']['averageRating'].toDouble(),
            serviceName: fav['service']['serviceName'],
            initialPrice: fav['service']['servicePrice'],
            isFav: true,
          ),
        );
      });
    }
    setState(() {
      _favourties = favourites;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        title: const Text(
          'Favourites',
          style: const TextStyle(
            fontSize: 24,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _loading
            ? const Center(
                child: const CircularProgressIndicator(),
              )
            : _favourties.isEmpty
                ? const Center(child: const Text('No favourites yet!'))
                : ListView.builder(
                    primary: true,
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: _favourties.length,
                    itemBuilder: (context, index) {
                      return ServiceProviderCard(
                        id: _favourties[index].id,
                        userName: _favourties[index].name,
                        profilePicUrl: _favourties[index].profileImg,
                        status: _favourties[index].stauts,
                        rating: _favourties[index].rating,
                        service: _favourties[index].serviceName,
                        distanceAway: _favourties[index].distanceAway,
                        startingPrice:
                            _favourties[index].initialPrice.toDouble(),
                        isFav: _favourties[index].isFav,
                        onHeartPressed: () {
                          print(index);
                          print(_favourties.length);
                          removeFavourite(_favourties[index].id);
                          _favourties.removeAt(index);
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
