import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restoro_fav_app/model/local_resto.dart';
import 'package:restoro_fav_app/model/local_resto_detail.dart';
import 'package:restoro_fav_app/model/local_resto_search.dart';
import 'package:restoro_fav_app/model/review.dart';

class ApiService {
  final http.Client client;
  ApiService({required this.client});

  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String imageSmall = '${_baseUrl}images/small/';
  static const String _list = 'list';
  static const String _detail = 'detail/';
  static const String _search = 'search?q=';
  static const String _post = 'review';

  Future<LocalRestaurant> restaurantList() async {
    try {
      final response = await client.get(Uri.parse("$_baseUrl$_list"));
      if (response.statusCode == 200) {
        return LocalRestaurant.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load restaurant list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load restaurant list: $e');
    }
  }

  Future<LocalRestaurantDetail> restaurantDetail(String id) async {
    final response = await client.get(Uri.parse("$_baseUrl$_detail$id"));
    if (response.statusCode == 200) {
      return LocalRestaurantDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load restaurant detail: ${response.statusCode}');
    }
  }

  Future<LocalRestaurantSearch> restaurantSearch(String id) async {
    try {
      final response = await client.get(Uri.parse("$_baseUrl$_search$id"));
      if (response.statusCode == 200) {
        return LocalRestaurantSearch.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load restaurant search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load restaurant search: $e');
    }
  }

  Future<dynamic> postReview(PostReview review) async {
    const url = "$_baseUrl$_post";
    final uri = Uri.parse(url);

    try {
      final response = await client
          .post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(review.toJson()),
      )
          .timeout(const Duration(seconds: 3)); // Timeout set to 3 seconds
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
