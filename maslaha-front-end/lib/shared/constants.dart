import 'package:flutter/material.dart';

//  All constant value will be here

const kPrimaryColor = Color(0xFF3669CB);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF447AE6), Color(0xFF223D73)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 250);

const kAuthMainColor = Color(0xff3669CB);
const kAuthSecondaryColor = Color(0xff4378E3);

// filter preferences keys

// price filter
const kPriceFilterState = 'isPriceFilterActive';
const kCurrentPriceFilterOption = 'selectedPriceOption';
const kFixedPriceOptionValue = 'fixedPriceValue';
const kRangePriceOptionStartValue = 'rangePriceStartValue';
const kRangePriceOptionEndValue = 'rangePriceEndValue';

// distance filter
const kDistanceFilterState = 'isDistanceFilterActive';
const kDistanceFilterValue = 'distanceFilterValue';

// rating filter
const kRatingFilterState = 'isRatingFilterActive';
const kRatingFilterValue = 'ratingFilterValue';

// availability filter
const kAvailabilityFilterState = 'isAvailabilityFilterActive';
