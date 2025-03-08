import 'dart:convert';
import 'package:restoro_fav_app/model/resto.dart';

LocalRestaurantSearch localRestaurantSearchFromJson(String str) =>
    LocalRestaurantSearch.fromJson(json.decode(str));

String localRestaurantSearchToJson(LocalRestaurantSearch data) =>
    json.encode(data.toJson());

class LocalRestaurantSearch {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  LocalRestaurantSearch({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory LocalRestaurantSearch.fromJson(Map<String, dynamic> json) {
    return LocalRestaurantSearch(
      error: json["error"],
      founded: json["founded"],
      restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "founded": founded,
      "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
  }
}
