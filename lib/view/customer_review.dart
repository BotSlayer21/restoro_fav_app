import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoro_fav_app/model/local_resto_detail.dart';
import 'package:restoro_fav_app/utils/result_state.dart';
import 'package:restoro_fav_app/view/customer_add_review.dart';
import 'package:restoro_fav_app/provider/resto_detail_provider.dart';

class CustomerReviews extends StatelessWidget {
  static const routeName = '/customer_reviews';
  final String id;
  const CustomerReviews({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AddReview.routeName,
                    arguments: {
                      'id': id,
                    });
              },
              child: Row(
                children: [
                  const Icon(Icons.add, color: Colors.black),
                  Text(
                    "Tambah Review",
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              )),
        ],
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, restaurantDetail, _) {
          if (restaurantDetail.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (restaurantDetail.state == ResultState.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.black,
                      foregroundColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Provider.of<RestaurantDetailProvider>(context, listen: false)
                          .fetchDataAgain();
                    },
                    child: const Icon(Icons.refresh),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: restaurantDetail.result.restaurant.customerReviews.length,
                    itemBuilder: (context, index) {
                      var review = restaurantDetail.result.restaurant.customerReviews[index];
                      return _buildReview(context, review);
                    },
                  ),
                ],
              ),
            );
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
                        Provider.of<RestaurantDetailProvider>(context,
                            listen: false)
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
                child: Text(
                  restaurantDetail.message,
                ),
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
      ),
    );
  }
}

Widget _buildReview(BuildContext context, CustomerReview reviews) {
  return GestureDetector(
    onTap: () {},
    child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 10),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.1,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviews.name.toString(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        reviews.review.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                      Text(
                        reviews.date.toString(),
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
