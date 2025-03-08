import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restoro_fav_app/data/api/api_service.dart';
import 'package:restoro_fav_app/model/local_resto_detail.dart';
import 'package:restoro_fav_app/utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  RestaurantDetailProvider({required this.apiService, required this.id}) {
    _fetchDetail();
  }

  late LocalRestaurantDetail _restaurantResult;

  late ResultState _state;
  String _message = '';

  String get message => _message;

  LocalRestaurantDetail get result => _restaurantResult;

  ResultState get state => _state;

  Future<void> _fetchDetail() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      await apiService
          .restaurantDetail(id)
          .timeout(const Duration(seconds: 4))
          .then((restaurant) {
        _state = ResultState.hasData;
        _restaurantResult = restaurant;
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
    await _fetchDetail();
  }
}