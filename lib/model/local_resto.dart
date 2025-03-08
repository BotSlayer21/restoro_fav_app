import 'dart:convert';

import 'package:restoro_fav_app/model/resto.dart';

LocalRestaurant localRestaurantFromJson(String str) =>
    LocalRestaurant.fromJson(json.decode(str));

String localRestaurantToJson(LocalRestaurant data) =>
    json.encode(data.toJson());

class LocalRestaurant {
  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  LocalRestaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory LocalRestaurant.fromJson(Map<String, dynamic> json) {
    return LocalRestaurant(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "count": count,
      "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
  }
}

