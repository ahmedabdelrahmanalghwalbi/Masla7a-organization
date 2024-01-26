import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../providers/category_id.dart';
import '../../providers/search_result.dart';
import 'package:provider/provider.dart';
import 'category_screen.dart';
import 'filter_screen.dart';
import 'search_screen.dart';
import '../../shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/size_config.dart';
import 'components/home_search_bar.dart';
import '../drawer/app_drawer.dart';
import '../home/components/special_offer_cards.dart';
import '../home/components/top_worker_cards.dart';
import 'components/category_card.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
// with AutomaticKeepAliveClientMixin
{
  var _userName = '';
  var _location = '';
  var _profilePicUrl = '';

  final _pageController = PageController(initialPage: 1, keepPage: true);
  var _currentPageIndex = 1;

  _getUserPresentationData() async {
    var userPrefs = await SharedPreferences.getInstance();
    var uid = userPrefs.getString('id');
    var currentToken = userPrefs.getString('token');

    var url = Uri.parse('https://masla7a.herokuapp.com/home/$uid');
    var request = http.Request('GET', url);
    request.headers.addAll({'x-auth-token': '$currentToken'});
    var response = await request.send();

    final respStr = await response.stream.bytesToString();
    var resBody = json.decode(respStr);

    print("***************************** $resBody");

    if (response.statusCode == 200) {
      setState(() {
        var name = resBody['user']['name'].split(' ');
        print(name);
        _userName = '${name[0]} ${name.length > 1 ? name[1] : ''}';
        _location =
            '${resBody['user']['location']['city']}, ${resBody['user']['location']['countryCode']}';
        _profilePicUrl = resBody['user']['profilePic'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserPresentationData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    SizeConfig().init(context);
    var catIDHandler = Provider.of<CategoryID>(context);
    return AppDrawer(
      userName: _userName,
      location: _location,
      profilePicUrl: _profilePicUrl,
      fab: _currentPageIndex != 1
          ? FloatingActionButton(
              onPressed: () {
                if (_currentPageIndex == 0) {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOutSine);
                } else {
                  FocusScope.of(context).unfocus();
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOutSine);
                }
              },
              backgroundColor: kPrimaryColor,
              child: Icon(
                _currentPageIndex == 0 ? Icons.arrow_forward : Icons.arrow_back,
                color: Colors.white,
              ),
            )
          : null,
      fabLocation: _currentPageIndex == 0
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.startFloat,
      home: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 6,
                  child: HomeSearchBar(
                    onPressed: () {
                      _pageController.animateToPage(
                        2,
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeInOutSine,
                      );
                    },
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      print('filters pressed!');
                      FocusScope.of(context).unfocus();

                      Navigator.pushNamed(context, FilterScreen.routeName);
                    },
                    child: Container(
                      width: getProportionateScreenWidth(45),
                      height: getProportionateScreenHeight(56),
                      padding: const EdgeInsets.all(9),
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 5,
                            ),
                          ]),
                      child: SvgPicture.asset(
                        'assets/icons/search_icons/filters.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  if (value != 2) FocusScope.of(context).unfocus();
                  setState(() {
                    _currentPageIndex = value;
                  });
                  if (value == 1)
                    Provider.of<SearchResult>(context, listen: false)
                        .clearSearchResultList();
                },
                pageSnapping: true,
                children: [
                  CategoryScreen(catID: catIDHandler.categoryID),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle(
                            'How can we serve you, ${_userName.split(' ')[0]} ?'),
                        CategoryCard(
                          onCatPresss: () {
                            _pageController.previousPage(
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOutSine);
                          },
                        ),
                        buildSectionTitle('Top Workers'),
                        TopWorkerCards(),
                        buildSectionTitle('Special Offers'),
                        SpecialOfferCards(),
                      ],
                    ),
                  ),
                  SearchScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String sectionTitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Text(
        sectionTitle,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'OpenSans',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}
