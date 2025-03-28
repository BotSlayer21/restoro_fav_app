import 'package:restoro_fav_app/model/resto.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating REAL
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    try {
      final db = await database;
      await db!.insert(_tblFavorite, restaurant.toJson());
    } catch (e) {
      throw Exception('Failed to insert favorite: $e');
    }
  }

  Future<List<Restaurant>> getFavorites() async {
    try {
      final db = await database;
      List<Map<String, dynamic>> results = await db!.query(_tblFavorite);

      return results.map((res) => Restaurant.fromJson(res)).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }

  Future<Map> getFavoriteById(String id) async {
    try {
      final db = await database;

      List<Map<String, dynamic>> results = await db!.query(
        _tblFavorite,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (results.isNotEmpty) {
        return results.first;
      } else {
        return {};
      }
    } catch (e) {
      throw Exception('Failed to fetch favorite by ID: $e');
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      final db = await database;

      await db!.delete(
        _tblFavorite,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }
}
