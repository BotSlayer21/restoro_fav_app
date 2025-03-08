import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/widgets/custom_search_delegate.dart';
import 'package:restoro_fav_app/widgets/build_resto_item.dart';
import 'package:restoro_fav_app/provider/resto_provider.dart';
import 'package:restoro_fav_app/utils/result_state.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(headerSliverBuilder: (_, __) {
        return [
          SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            expandedHeight: 150,
            toolbarHeight: 65,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/restaurants.jpg',
                fit: BoxFit.fitWidth,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Restaurant App",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 16),
            ),
          ),
        ];
      }, body: Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.result.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = state.result.restaurants[index];
                return buildRestaurantItem(context, restaurant);
              },
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            if (state.message.contains('No internet connection')) {
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
                        Provider.of<RestaurantProvider>(context, listen: false)
                            .fetchDataAgain();
                      },
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      )),
    );
  }
}