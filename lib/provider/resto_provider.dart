import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/local_resto.dart';
import 'package:restoro_fav_app/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    _fetchAllRestaurants();
  }

  late LocalRestaurant _restaurantResult;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  LocalRestaurant get result => _restaurantResult;

  ResultState get state => _state;

  Future<void> _fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      await apiService
          .restaurantList()
          .timeout(const Duration(seconds: 4))
          .then((restaurant) {
        if (restaurant.restaurants.isEmpty) {
          _state = ResultState.noData;
          _message = 'Empty Data';
        } else {
          _state = ResultState.hasData;
          _restaurantResult = restaurant;
        }
        notifyListeners();
      }).catchError((e) {
        _state = ResultState.error;
        _message = 'No internet connection';
        notifyListeners();
        throw Exception('No internet connection');
      });
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error --> $e';
      notifyListeners();
    }
  }

  Future<void> fetchDataAgain() async {
    await _fetchAllRestaurants();
  }
}
