import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

addToFavourites(String spID) async {
  final prefs = await SharedPreferences.getInstance();
  var currentToken = prefs.getString('token');

  var url =
      Uri.parse('https://masla7a.herokuapp.com/favourites/add-favourite/');
  var response = await http.post(url,
      headers: {
        'x-auth-token': '$currentToken',
        'content-type': 'application/json'
      },
      body: json.encode({'serviceProviderId': spID}));

  var resBody = json.decode(response.body);
  print(resBody);
}

removeFavourite(String spID) async {
  final prefs = await SharedPreferences.getInstance();
  var currentToken = prefs.getString('token');

  var url = Uri.parse(
      'https://masla7a.herokuapp.com/favourites/remove-favourite/$spID');
  var request = http.Request('GET', url);
  request.headers.addAll({'x-auth-token': '$currentToken'});

  var response = await request.send();

  final respStr = await response.stream.bytesToString();
  var resBody = json.decode(respStr);

  print(resBody);
}
