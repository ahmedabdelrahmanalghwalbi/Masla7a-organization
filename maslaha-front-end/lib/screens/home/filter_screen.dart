import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../providers/filters.dart';
import 'package:provider/provider.dart';
import 'components/filter_section.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';

enum AvailabilityFilteringOptions { AvailableNow, AvailableLater }

class FilterScreen extends StatefulWidget {
  static const routeName = '/search-filters';

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  AvailabilityFilteringOptions? _availabilityFilteringOption =
      AvailabilityFilteringOptions.AvailableNow;

  var _isFiltersInitialized = false;

  @override
  Widget build(BuildContext context) {
    var _filterHandler = Provider.of<Filters>(context);
    var filterState = _filterHandler.getfiltersState;
    if (!_isFiltersInitialized) {
      setState(() {
        _isFiltersInitialized = true;
      });
      _filterHandler.initializeFiltersState();
    }
    // Provider.of<HomeViewIndex>(context).updateViewIndex(2);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () {
            _filterHandler.printKeysValues();
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Fliters',
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                FilterSection(
                  filterTitle: 'Price',
                  filterDescription:
                      'Helps you find an affordable service provider that suits your needs, specify a fixed price or a range to efficiently manage your budget.',
                  enabled: filterState['price'],
                  onEnabled: (toggler) {
                    _filterHandler.toggleFilterState(
                        FilteringOptions.Price, toggler);
                  },
                  children: [
                    RadioListTile<PriceFilteringOptions>(
                      title: const Text(
                        'Amount',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Fixed value for price.'),
                      value: PriceFilteringOptions.FixedValue,
                      groupValue: PriceFilteringOptions.values[
                          _filterHandler.currentSelectedPriceFilterOption],
                      selected: PriceFilteringOptions.values[_filterHandler
                                  .currentSelectedPriceFilterOption] ==
                              PriceFilteringOptions.FixedValue
                          ? true
                          : false,
                      dense: true,
                      onChanged: filterState['price']
                          ? (newOption) {
                              _filterHandler.togglePriceFilteringOptions(
                                  newOption!.index);
                            }
                          : null,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextFormField(
                        onChanged: filterState['price'] &&
                                PriceFilteringOptions.values[_filterHandler
                                        .currentSelectedPriceFilterOption] ==
                                    PriceFilteringOptions.FixedValue
                            ? (val) {
                                _filterHandler
                                    .updateFixedPriceFilterOptionValue(
                                        int.parse(val));
                              }
                            : null,
                        keyboardType: TextInputType.number,
                        enabled: PriceFilteringOptions.values[_filterHandler
                                    .currentSelectedPriceFilterOption] ==
                                PriceFilteringOptions.FixedValue
                            ? true
                            : false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffE4DCDC)),
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Enter price you want in L.E.",
                          hintStyle: const TextStyle(
                              color: Colors.black45, fontSize: 14),
                          prefixIcon: const Icon(
                            Icons.attach_money_outlined,
                            color: Color(0xffA0BBF0),
                          ),
                        ),
                      ),
                    ),
                    RadioListTile<PriceFilteringOptions>(
                      title: const Text(
                        'Range',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text('Range value for price.'),
                      value: PriceFilteringOptions.Range,
                      groupValue: PriceFilteringOptions.values[
                          _filterHandler.currentSelectedPriceFilterOption],
                      selected: PriceFilteringOptions.values[_filterHandler
                                  .currentSelectedPriceFilterOption] ==
                              PriceFilteringOptions.Range
                          ? true
                          : false,
                      dense: true,
                      onChanged: filterState['price']
                          ? (newOption) {
                              _filterHandler.togglePriceFilteringOptions(
                                  newOption!.index);
                            }
                          : null,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: SfRangeSliderTheme(
                        data: SfRangeSliderThemeData(
                          activeLabelStyle: TextStyle(
                            color: PriceFilteringOptions.values[_filterHandler
                                            .currentSelectedPriceFilterOption] ==
                                        PriceFilteringOptions.Range &&
                                    filterState['price']
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          inactiveLabelStyle: TextStyle(
                            color: PriceFilteringOptions.values[_filterHandler
                                            .currentSelectedPriceFilterOption] ==
                                        PriceFilteringOptions.Range &&
                                    filterState['price']
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        child: SfRangeSlider(
                          min: 50.0,
                          max: 10000.0,
                          values: SfRangeValues(
                              _filterHandler.rangePriceOptionStartValue,
                              _filterHandler.rangePriceOptionEndValue),
                          showTicks: true,
                          showLabels: true,
                          labelFormatterCallback: (actualValue, formattedText) {
                            formattedText = actualValue == 10000
                                ? '${actualValue.toInt()}+ L.E.'
                                : '${actualValue.toInt()} L.E.';

                            return formattedText;
                          },
                          endThumbIcon: FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(7, 4, 4, 4),
                              child: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                            ),
                          ),
                          startThumbIcon: FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(9, 4, 0, 4),
                              child: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                            ),
                          ),
                          enableTooltip: true,
                          tooltipShape: SfPaddleTooltipShape(),
                          tooltipTextFormatterCallback:
                              (actualValue, formattedText) {
                            formattedText = '${actualValue.toInt()} LE.';
                            return formattedText;
                          },
                          onChanged: PriceFilteringOptions.values[_filterHandler
                                          .currentSelectedPriceFilterOption] ==
                                      PriceFilteringOptions.Range &&
                                  filterState['price']
                              ? (newRange) {
                                  _filterHandler
                                      .updateRangePriceFilterOptionValue(
                                          newRange.start.toInt(),
                                          newRange.end.toInt());
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                FilterSection(
                  filterTitle: 'Distance',
                  filterDescription:
                      'Find service providers nearest to you, or maybe a little far up to 20km from your location, it\'s your call, use the slider to set the desired distance.',
                  enabled: filterState['distance'],
                  onEnabled: (toggler) {
                    _filterHandler.toggleFilterState(
                        FilteringOptions.Distance, toggler);
                  },
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: SfSliderTheme(
                        data: SfSliderThemeData(
                          activeLabelStyle: TextStyle(
                            color: filterState['distance']
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          inactiveLabelStyle: TextStyle(
                            color: filterState['distance']
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        child: SfSlider(
                          min: 1,
                          max: 20,
                          value: _filterHandler.distanceValue,
                          showTicks: true,
                          showLabels: true,
                          labelFormatterCallback: (actualValue, formattedText) {
                            formattedText = actualValue == 10000
                                ? '${actualValue.toInt()}+ km.'
                                : '${actualValue.toInt()} km.';
                            return formattedText;
                          },
                          enableTooltip: true,
                          tooltipShape: SfPaddleTooltipShape(),
                          tooltipTextFormatterCallback:
                              (actualValue, formattedText) {
                            formattedText = '${actualValue.toInt()} km.';
                            return formattedText;
                          },
                          onChanged: filterState['distance']
                              ? (newValue) {
                                  _filterHandler
                                      .updateDistanceFilterOptionValue(
                                          newValue.toInt());
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                FilterSection(
                  filterTitle: 'Rating',
                  filterDescription:
                      'Control rating of the shown service providers as you desire.',
                  enabled: filterState['rating'],
                  onEnabled: (toggler) {
                    _filterHandler.toggleFilterState(
                        FilteringOptions.Rating, toggler);
                  },
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: RatingBar.builder(
                        initialRating: _filterHandler.ratingValue,
                        allowHalfRating: true,
                        maxRating: 5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                        itemSize: 35,
                        itemBuilder: (_, index) {
                          return Icon(
                            Icons.star_rate_rounded,
                            color: filterState['rating']
                                ? Colors.amber
                                : Colors.grey,
                          );
                        },
                        glow: false,
                        ignoreGestures: !filterState['rating'],
                        onRatingUpdate: (rating) {
                          _filterHandler.updateRatingFilterOptionValue(rating);
                        },
                      ),
                    ),
                  ],
                ),
                // FilterSection(
                //   filterTitle: 'Availability',
                //   filterDescription:
                //       'Make your order in a quick manner; only show service providers available and ready to take your order, want it later? No problem, we got you covered.',
                //   enabled: filterState['availability'],
                //   onEnabled: (toggler) {
                //     _filterHandler.toggleFilterState(
                //         FilteringOptions.Availability, toggler);
                //   },
                //   children: [
                //     RadioListTile<AvailabilityFilteringOptions>(
                //       title: const Text(
                //         'Currently Available',
                //         style: const TextStyle(fontWeight: FontWeight.w600),
                //       ),
                //       subtitle: const Text(
                //           'Only online and available service providers.'),
                //       value: AvailabilityFilteringOptions.AvailableNow,
                //       groupValue: _availabilityFilteringOption,
                //       selected: _availabilityFilteringOption ==
                //               AvailabilityFilteringOptions.AvailableNow
                //           ? true
                //           : false,
                //       dense: true,
                //       onChanged: filterState['availability']
                //           ? (newOption) {
                //               setState(() {
                //                 _availabilityFilteringOption = newOption;
                //               });
                //             }
                //           : null,
                //     ),
                //     RadioListTile<AvailabilityFilteringOptions>(
                //       title: const Text(
                //         'Available later',
                //         style: const TextStyle(fontWeight: FontWeight.w600),
                //       ),
                //       subtitle: const Text('Choose the time that suits you.'),
                //       value: AvailabilityFilteringOptions.AvailableLater,
                //       groupValue: _availabilityFilteringOption,
                //       selected: _availabilityFilteringOption ==
                //               AvailabilityFilteringOptions.AvailableLater
                //           ? true
                //           : false,
                //       dense: true,
                //       onChanged: filterState['availability']
                //           ? (newOption) {
                //               setState(() {
                //                 _availabilityFilteringOption = newOption;
                //               });
                //             }
                //           : null,
                //     ),
                //     Visibility(
                //       visible: filterState['availability'] &&
                //               _availabilityFilteringOption ==
                //                   AvailabilityFilteringOptions.AvailableLater
                //           ? true
                //           : false,
                //       child: Container(
                //         margin: const EdgeInsets.symmetric(
                //             vertical: 10, horizontal: 14),
                //         child: FlutterDatePickerTimeline(
                //           startDate: DateTime.now(),
                //           endDate: DateTime.now().add(Duration(days: 30)),
                //           initialSelectedDate: DateTime.now(),
                //           initialFocusedDate: DateTime.now(),
                //           unselectedItemBackgroundColor: Colors.grey.shade400,
                //           unselectedItemTextStyle:
                //               const TextStyle(color: Colors.white),
                //           selectedItemBackgroundColor: Colors.blue,
                //           selectedItemTextStyle:
                //               const TextStyle(color: Colors.white),
                //           onSelectedDateChange: (selectedDate) {
                //             print(selectedDate);
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _filterHandler.resetFiltersState();
                    },
                    child: const Text('Reset'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red.shade400),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _filterHandler.saveFiltersState();
                      _filterHandler.saveFiltersData();
                      _filterHandler.printKeysValues();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apply'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
