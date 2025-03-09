import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/resto.dart';
import 'package:restoro_fav_app/provider/db_provider.dart';
import 'package:restoro_fav_app/view/resto_detail_page.dart';

Widget buildRestaurantItem(BuildContext context, Restaurant restaurant) {
  return Consumer<DatabaseProvider>(builder: (context, provider, child) {
    return FutureBuilder<bool>(
        future: provider.isFavorited(restaurant.id),
        builder: (context, snapshot) {
          var isFavorited = snapshot.data ?? false;
          return Row(
            children: [
              Flexible(
                flex: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RestaurantDetailPage.routeName,
                        arguments: {
                          'id': restaurant.id,
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                      style:
                                      Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow.shade700),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(restaurant.rating.toString(),
                                      style:
                                      Theme.of(context).textTheme.bodyMedium),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                      onPressed: () {
                        if (isFavorited == true) {
                          provider.removeFavorite(restaurant.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text(
                                      '${restaurant.name} dihapus dari daftar favorit')),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else {
                          provider.addFavorite(restaurant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                  child: Text(
                                      '${restaurant.name} ditambahkan ke daftar favorit')),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_outline,
                        color: isFavorited ? Colors.pink : Colors.red,
                      )),
                ),
              )
            ],
          );
        });
  });
}