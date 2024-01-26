import 'package:flutter/material.dart';
import 'package:maslaha/utils/size_config.dart';
import '../../utils/toggle_favourite.dart';
import '../../providers/search_result.dart';
import 'package:provider/provider.dart';
import '../../widgets/service_provider_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _isFavLoading = false;

  @override
  Widget build(BuildContext context) {
    var searchProviderHandler = Provider.of<SearchResult>(context);
    var searchResults = searchProviderHandler.serviceProviders;
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: getProportionateScreenHeight(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${searchResults.length} Results found.',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                PopupMenuButton(
                    icon: const Icon(
                      Icons.sort_rounded,
                      color: Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (selectedOption) {
                      switch (selectedOption) {
                        case SortOptions.MostRated:
                          searchProviderHandler.updateSortOption('most_rated');
                          print('most rated');
                          break;
                        case SortOptions.Nearest:
                          searchProviderHandler.updateSortOption('nearest');
                          print('nearest');
                          break;
                        case SortOptions.PriceDesc:
                          searchProviderHandler.updateSortOption('price_desc');
                          print('highest price');
                          break;
                        case SortOptions.PriceAsc:
                          searchProviderHandler.updateSortOption('price_asc');
                          print('lowest price');
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (ctx) {
                      return [
                        PopupMenuItem(
                          child: const Text('Most Rated'),
                          value: SortOptions.MostRated,
                        ),
                        PopupMenuItem(
                          child: const Text('Nearest'),
                          value: SortOptions.Nearest,
                        ),
                        PopupMenuItem(
                          child: const Text('Highest price'),
                          value: SortOptions.PriceDesc,
                        ),
                        PopupMenuItem(
                          child: const Text('Lowest Price'),
                          value: SortOptions.PriceAsc,
                        ),
                      ];
                    }),
              ],
            )),
        Expanded(
          child: searchResults.isEmpty
              ? Center(
                  child: const Text('No result yet!'),
                )
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ServiceProviderCard(
                      id: searchResults[index].id,
                      userName: searchResults[index].name,
                      profilePicUrl: searchResults[index].profileImg,
                      status: searchResults[index].stauts,
                      rating: searchResults[index].rating,
                      service: searchResults[index].serviceName,
                      distanceAway:
                          searchResults[index].distanceAway.toDouble(),
                      startingPrice:
                          searchResults[index].initialPrice.toDouble(),
                      isFav: searchResults[index].isFav,
                      isLoading: _isFavLoading,
                      onHeartPressed: () async {
                        if (searchResults[index].isFav == true) {
                          setState(() {
                            _isFavLoading = true;
                          });
                          await removeFavourite(searchResults[index].id);
                          await searchProviderHandler
                              .search(searchProviderHandler.searchKeyword);
                          setState(() {
                            _isFavLoading = false;
                          });
                        } else {
                          setState(() {
                            _isFavLoading = true;
                          });
                          await addToFavourites(searchResults[index].id);
                          await searchProviderHandler
                              .search(searchProviderHandler.searchKeyword);
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
