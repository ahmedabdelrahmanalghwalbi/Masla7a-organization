import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/constants.dart';

enum FilteringOptions { Price, Distance, Rating, Availability }
enum PriceFilteringOptions { FixedValue, Range }
enum AvailabilityFilteringOptions { AvailableNow, AvailableLater }

class Filters with ChangeNotifier {
  Map<String, bool> _filtersState = {
    'price': false,
    'distance': false,
    'rating': false,
    'availability': false,
  };

  var currentSelectedPriceFilterOption = PriceFilteringOptions.FixedValue.index;
  var fixedPriceOptionValue = 0;
  var rangePriceOptionStartValue = 50;
  var rangePriceOptionEndValue = 2000;

  var distanceValue = 1;

  var ratingValue = 1.0;

  get getfiltersState {
    return {..._filtersState};
  }

  initializeFiltersState() async {
    final prefs = await SharedPreferences.getInstance();

    _filtersState['price'] = prefs.getBool(kPriceFilterState) ?? false;
    _filtersState['distance'] = prefs.getBool(kDistanceFilterState) ?? false;
    _filtersState['rating'] = prefs.getBool(kRatingFilterState) ?? false;
    _filtersState['availability'] =
        prefs.getBool(kAvailabilityFilterState) ?? false;

    currentSelectedPriceFilterOption =
        prefs.getInt(kCurrentPriceFilterOption) ??
            PriceFilteringOptions.FixedValue.index;
    fixedPriceOptionValue = prefs.getInt(kFixedPriceOptionValue) ?? 0;
    rangePriceOptionStartValue =
        prefs.getInt(kRangePriceOptionStartValue) ?? 50;
    rangePriceOptionEndValue = prefs.getInt(kRangePriceOptionEndValue) ?? 2000;
    distanceValue = prefs.getInt(kDistanceFilterValue) ?? 1;
    ratingValue = prefs.getDouble(kRatingFilterValue) ?? 1.0;

    notifyListeners();
  }

  saveFiltersState() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(kPriceFilterState, _filtersState['price'] as bool);

    prefs.setInt(kCurrentPriceFilterOption, currentSelectedPriceFilterOption);

    prefs.setBool(kDistanceFilterState, _filtersState['distance'] as bool);

    prefs.setBool(kRatingFilterState, _filtersState['rating'] as bool);

    prefs.setBool(
        kAvailabilityFilterState, _filtersState['availability'] as bool);
  }

  saveFiltersData() async {
    final prefs = await SharedPreferences.getInstance();

    if (_filtersState['price'] as bool &&
        currentSelectedPriceFilterOption == 0) {
      prefs.setInt(kFixedPriceOptionValue, fixedPriceOptionValue);
      prefs.remove(kRangePriceOptionStartValue);
      prefs.remove(kRangePriceOptionEndValue);
    } else {
      prefs.remove(kFixedPriceOptionValue);
    }

    if (_filtersState['price'] as bool &&
        currentSelectedPriceFilterOption == 1) {
      prefs.setInt(kRangePriceOptionStartValue, rangePriceOptionStartValue);
      prefs.setInt(kRangePriceOptionEndValue, rangePriceOptionEndValue);
      prefs.remove(kFixedPriceOptionValue);
    } else {
      prefs.remove(kRangePriceOptionStartValue);
      prefs.remove(kRangePriceOptionEndValue);
    }

    if (_filtersState['distance'] as bool)
      prefs.setInt(kDistanceFilterValue, distanceValue);
    else
      prefs.remove(kDistanceFilterValue);

    if (_filtersState['rating'] as bool)
      prefs.setDouble(kRatingFilterValue, ratingValue);
    else
      prefs.remove(kRatingFilterValue);
  }

  resetFiltersState() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove(kPriceFilterState);
    _filtersState['price'] = false;

    prefs.remove(kCurrentPriceFilterOption);

    prefs.remove(kDistanceFilterState);
    _filtersState['distance'] = false;

    prefs.remove(kRatingFilterState);
    _filtersState['rating'] = false;

    prefs.remove(kAvailabilityFilterState);
    _filtersState['availability'] = false;

    prefs.remove(kFixedPriceOptionValue);
    prefs.remove(kRangePriceOptionStartValue);
    prefs.remove(kRangePriceOptionEndValue);
    prefs.remove(kDistanceFilterValue);
    prefs.remove(kRatingFilterValue);

    notifyListeners();
  }

  toggleFilterState(FilteringOptions filter, bool state) {
    switch (filter) {
      case FilteringOptions.Price:
        _filtersState['price'] = state;
        notifyListeners();
        break;

      case FilteringOptions.Distance:
        _filtersState['distance'] = state;
        notifyListeners();
        break;

      case FilteringOptions.Rating:
        _filtersState['rating'] = state;
        notifyListeners();
        break;

      case FilteringOptions.Availability:
        _filtersState['availability'] = state;
        notifyListeners();
        break;

      default:
        break;
    }
  }

  togglePriceFilteringOptions(int option) {
    currentSelectedPriceFilterOption = option;

    notifyListeners();
  }

  updateFixedPriceFilterOptionValue(int price) {
    fixedPriceOptionValue = price;

    notifyListeners();
  }

  updateRangePriceFilterOptionValue(int start, int end) {
    rangePriceOptionStartValue = start;
    rangePriceOptionEndValue = end;

    notifyListeners();
  }

  updateDistanceFilterOptionValue(int distance) {
    distanceValue = distance;

    notifyListeners();
  }

  updateRatingFilterOptionValue(double rating) {
    ratingValue = rating;

    notifyListeners();
  }

  printKeysValues() async {
    final prefs = await SharedPreferences.getInstance();

    var priceFilterState = prefs.getBool(kPriceFilterState);
    print('price state: $priceFilterState');

    var priceFilterSelectedOption = prefs.getInt(kCurrentPriceFilterOption);
    print('price option: $priceFilterSelectedOption');

    var fixedPriceValue = prefs.getInt(kFixedPriceOptionValue);
    print('fixed value: $fixedPriceValue');

    var rangePriceStartValue = prefs.getInt(kRangePriceOptionStartValue);
    print('range start value: $rangePriceStartValue');

    var rangePriceEndValue = prefs.getInt(kRangePriceOptionEndValue);
    print('range end value: $rangePriceEndValue');

    var distanceFilterState = prefs.getBool(kDistanceFilterState);
    print('distance state: $distanceFilterState');

    var distanceValue = prefs.getInt(kDistanceFilterValue);
    print('distance value: $distanceValue');

    var ratingFilterState = prefs.getBool(kRatingFilterState);
    print('rating state: $ratingFilterState');

    var ratingValue = prefs.getDouble(kRatingFilterValue);
    print('rating value: $ratingValue');
  }
}
