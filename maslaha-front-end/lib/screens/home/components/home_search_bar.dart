import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/search_result.dart';
import 'package:provider/provider.dart';

class HomeSearchBar extends StatefulWidget {
  final Function()? onPressed;

  HomeSearchBar({this.onPressed});

  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  @override
  Widget build(BuildContext context) {
    var searchRequest = Provider.of<SearchResult>(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(0.0, 2.0),
              blurRadius: 1,
            ),
          ]),
      child: TextField(
        onChanged: (keyword) async {
          searchRequest.updateKeyword(keyword);
          if (keyword.isNotEmpty) {
            await searchRequest.search(keyword);
          } else {
            searchRequest.clearSearchResultList();
          }
        },
        onTap: widget.onPressed,
        enabled: true,
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset(
            'assets/icons/search_icons/search.svg',
            fit: BoxFit.scaleDown,
          ),
          hintText: 'names, @usernames & #services.',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
