import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/resto.dart';
import 'package:restoro_fav_app/utils/result_state.dart';
import 'package:restoro_fav_app/view/resto_detail_page.dart';
import 'package:restoro_fav_app/provider/resto_search_provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return ChangeNotifierProvider<RestaurantSearchProvider>(
        create: (_) =>
            RestaurantSearchProvider(apiService: ApiService(client: Client()), id: query),
        child: Consumer<RestaurantSearchProvider>(
          builder: (context, search, _) {
            if (search.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (search.state == ResultState.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: search.result.restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = search.result.restaurants[index];
                  return _buildSearchedRestaurantItem(context, restaurant);
                },
              );
            } else if (search.state == ResultState.noData) {
              return Center(
                child: Material(
                  child: Text(search.message),
                ),
              );
            } else if (search.state == ResultState.error) {
              if (search.message.contains('No internet connection') ||
                  search.message.contains('No address')) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Periksa Koneksi Internet Anda'),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          search.fetchData(query);
                        },
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Material(
                    child: Text(search.message),
                  ),
                );
              }
            } else {
              return const Center(
                child: Material(
                  child: Text(''),
                ),
              );
            }
          },
        ),
      );
    } else {
      return const Center(child: Text('Masukkan Nama Restaurant Anda'));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Cari Nama Restaurant Anda'));
  }

  Widget _buildSearchedRestaurantItem(
      BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: {
              'id': restaurant.id,
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, bottom: 20),
        child: Row(
          children: [
            SizedBox(
              width: 125,
              height: 125,
              child: Hero(
                tag: restaurant.pictureId.toString(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    ApiService.imageSmall.toString() +
                        restaurant.pictureId.toString(),
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          error.toString().contains('Socket')
                              ? "Periksa Koneksi Internet Anda"
                              : 'Masalah: $error',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red.shade900,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(restaurant.city.toString(),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow.shade700),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}