import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/local_resto_search.dart';
import 'package:restoro_fav_app/utils/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  RestaurantSearchProvider({required this.apiService, required this.id}){
    _searchRestaurants(id);
  }

  late LocalRestaurantSearch _restaurantResult;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  LocalRestaurantSearch get result => _restaurantResult;

  ResultState get state => _state;

  Future<void> _searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      await apiService
          .restaurantSearch(query)
          .timeout(const Duration(seconds: 4))
          .then((restaurant) {
        if (restaurant.restaurants.isEmpty) {
          _state = ResultState.noData;
          _message = 'Data Tidak Ditemukan';
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

  Future<void> fetchData(String query) async {
    await _searchRestaurants(query);
  }
}