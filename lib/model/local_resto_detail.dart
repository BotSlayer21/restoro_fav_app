import 'dart:convert';

LocalRestaurantDetail localRestaurantDetailFromJson(String str) =>
    LocalRestaurantDetail.fromJson(json.decode(str));

String localRestaurantDetailToJson(LocalRestaurantDetail data) =>
    json.encode(data.toJson());

class LocalRestaurantDetail {
  bool error;
  String message;
  RestaurantDetail restaurant;

  LocalRestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory LocalRestaurantDetail.fromJson(Map<String, dynamic> json) {
    return LocalRestaurantDetail(
      error: json["error"],
      message: json["message"],
      restaurant: RestaurantDetail.fromJson(json["restaurant"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "restaurant": restaurant.toJson(),
    };
  }
}

class RestaurantDetail {
  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<Category> categories;
  Menu menus;
  double rating;
  List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x))),
      menus: Menu.fromJson(json["menus"]),
      rating: json["rating"]?.toDouble(),
      customerReviews: List<CustomerReview>.from(
          json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "city": city,
      "address": address,
      "pictureId": pictureId,
      "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      "menus": menus.toJson(),
      "rating": rating,
      "customerReviews":
      List<dynamic>.from(customerReviews.map((x) => x.toJson())),
    };
  }
}

class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class CustomerReview {
  String name;
  String review;
  String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json["name"],
      review: json["review"],
      date: json["date"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "review": review,
      "date": date,
    };
  }
}

class Menu {
  List<Category> foods;
  List<Category> drinks;

  Menu({
    required this.foods,
    required this.drinks,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods:
      List<Category>.from(json["foods"].map((x) => Category.fromJson(x))),
      drinks:
      List<Category>.from(json["drinks"].map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
      "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
    };
  }
}
