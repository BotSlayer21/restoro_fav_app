import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/local_resto_detail.dart';
import 'package:restoro_fav_app/utils/result_state.dart';
import 'package:restoro_fav_app/view/customer_review.dart';
import 'package:restoro_fav_app/widgets/custom_scaffold.dart';
import 'package:restoro_fav_app/provider/resto_detail_provider.dart';
import 'package:restoro_fav_app/provider/resto_provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';
  const RestaurantDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: Consumer<RestaurantDetailProvider>(
      builder: (context, restaurantDetail, _) {
        if (restaurantDetail.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (restaurantDetail.state == ResultState.hasData) {
          return _buildDetailRestaurant(
              context, restaurantDetail.result.restaurant);
        } else if (restaurantDetail.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(restaurantDetail.message),
            ),
          );
        } else if (restaurantDetail.state == ResultState.error) {
          if (restaurantDetail.message.contains('No internet connection')) {
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
              child: Text(restaurantDetail.message),
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
    ));
  }
}

Widget _buildDetailRestaurant(
    BuildContext context, RestaurantDetail restaurant) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Hero(
            tag: restaurant.pictureId.toString(),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
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
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(restaurant.name.toString(),
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(restaurant.rating.toString(),
                        style: Theme.of(context).textTheme.titleMedium),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CustomerReviews.routeName,
                            arguments: {
                              'id': restaurant.id,
                            });
                      },
                      child: const Text(
                        "Lihat Review",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          decoration:
                          TextDecoration.underline, // Tambahkan garis bawah
                          decorationColor:
                          Colors.blueAccent, // Warna garis bawah
                          decorationThickness: 2.0, // Ketebalan garis bawah
                        ),
                      ),
                    )
                  ],
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
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("Deskripsi",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Text(
                restaurant.description.toString(),
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
            ],
          ),
          Text("Menu", style: Theme.of(context).textTheme.titleLarge),
          Text("Foods",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start),
          const SizedBox(
            height: 10,
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(restaurant.menus.foods.length, (index) {
              return Center(
                child: Card(
                  color: Colors.red.shade300,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Center(
                          child: Text(
                            restaurant.menus.foods[index].name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Text("Menu", style: Theme.of(context).textTheme.titleLarge),
                Text("Drinks", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children:
            List.generate(restaurant.menus.drinks.length - 1, (index) {
              return Center(
                child: Card(
                  color: Colors.green.shade300,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: Center(
                          child: Text(
                            restaurant.menus.drinks[index].name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    ),
  );
}
