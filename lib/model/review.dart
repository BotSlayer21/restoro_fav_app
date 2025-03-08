import 'dart:convert';
import 'package:restoro_fav_app/model/local_resto_detail.dart';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  Review({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      error: json["error"],
      message: json["message"],
      customerReviews: List<CustomerReview>.from(
          json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "customerReviews":
      List<dynamic>.from(customerReviews.map((x) => x.toJson())),
    };
  }
}

class PostReview {
  String id;
  String name;
  String review;

  PostReview({
    required this.id,
    required this.name,
    required this.review,
  });

  factory PostReview.fromJson(Map<String, dynamic> json) {
    return PostReview(
      name: json["name"],
      review: json["review"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "review": review,
    };
  }
}
