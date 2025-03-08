import 'package:flutter/material.dart';
import 'package:restoro_fav_app/data/db/db_helper.dart';
import 'package:restoro_fav_app/model/resto.dart';
import 'package:restoro_fav_app/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _state = ResultState.loading;
    _getFavorites();
  }

  late ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    try {
      final bookmarkedArticle = await databaseHelper.getFavoriteById(id);
      return bookmarkedArticle.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}