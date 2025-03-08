import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/provider/db_provider.dart';
import 'package:restoro_fav_app/utils/result_state.dart';
import 'package:restoro_fav_app/widgets/build_resto_item.dart';

class RestaurantFavorite extends StatelessWidget {
  const RestaurantFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Favorite Restaurants')),
        ),
        body: Consumer<DatabaseProvider>(
          builder: (_, provider, __) {
            if (provider.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: provider.favorites.length,
                itemBuilder: (context, index) {
                  return buildRestaurantItem(
                      context, provider.favorites[index]);
                },
              );
            } else {
              return Center(
                child: Material(
                  child: Text(provider.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}