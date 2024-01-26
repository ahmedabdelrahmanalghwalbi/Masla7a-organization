import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:maslaha/shared/constants.dart';
import '../models/service_provider_overview_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum SortOptions { PriceAsc, PriceDesc, MostRated, Popularity, Nearest }

class SearchResult with ChangeNotifier {
  List<ServiceProviderOverview> _serviceProviders = [];
  String searchKeyword = '';

  List<ServiceProviderOverview> get serviceProviders {
    return [..._serviceProviders];
  }

  search(String searchKeyword) async {
    var userPrefs = await SharedPreferences.getInstance();
    var currentToken = userPrefs.getString('token');
    var fixedPrice = userPrefs.getInt(kFixedPriceOptionValue);
    var startPrice = userPrefs.getInt(kRangePriceOptionStartValue);
    var endPrice = userPrefs.getInt(kRangePriceOptionEndValue);
    var distance = userPrefs.getInt(kDistanceFilterValue);
    var rating = userPrefs.getDouble(kRatingFilterValue);

    var url = Uri.https('masla7a.herokuapp.com', '/home/search/', {
      'search': searchKeyword,
      'price_from': fixedPrice != null
          ? fixedPrice.toString()
          : startPrice != null
              ? startPrice.toString()
              : '50',
      'price_to': endPrice != null ? endPrice.toString() : '999999',
      'distance': distance != null ? distance.toString() : '999999',
      'rating': rating != null ? rating.toString() : '1',
    });
    var response =
        await http.get(url, headers: {'x-auth-token': '$currentToken'});

    var resBody = json.decode(response.body);

    // print('response body:\n $resBody');
    print('keyword: $searchKeyword');

    if (response.statusCode == 200) {
      _serviceProviders.replaceRange(
          0,
          _serviceProviders.length,
          resBody['serviceProviders'].map(
            (serviceProvider) {
              return ServiceProviderOverview(
                id: serviceProvider['_id'],
                name: serviceProvider['name'],
                profileImg: serviceProvider['profilePic'],
                stauts: serviceProvider['availability'],
                isFav: serviceProvider['favourite'],
                distanceAway: double.parse(
                    serviceProvider['distance'].toStringAsFixed(1)),
                rating: serviceProvider['service']['averageRating'].toDouble(),
                serviceName: serviceProvider['service']['serviceName'],
                initialPrice: serviceProvider['service']['servicePrice'],
              );
            },
          ).cast<ServiceProviderOverview>());

      notifyListeners();
    }
  }

  clearSearchResultList() {
    _serviceProviders.clear();
  }

  updateSortOption(String sortBy) {
    if (sortBy == 'price_asc') {
      _serviceProviders.sort((a, b) {
        return a.initialPrice.compareTo(b.initialPrice);
      });

      notifyListeners();
    } else if (sortBy == 'price_desc') {
      _serviceProviders.sort((a, b) {
        return a.initialPrice.compareTo(b.initialPrice);
      });

      _serviceProviders = _serviceProviders.reversed.toList();
      notifyListeners();
    } else if (sortBy == 'nearest') {
      _serviceProviders.sort((a, b) {
        return a.distanceAway.compareTo(b.distanceAway);
      });

      notifyListeners();
    } else {
      _serviceProviders.sort((a, b) {
        return a.rating.compareTo(b.rating);
      });

      _serviceProviders = _serviceProviders.reversed.toList();
      notifyListeners();
    }
  }

  updateKeyword(String newKeyword) {
    searchKeyword = newKeyword;

    notifyListeners();
  }
}
