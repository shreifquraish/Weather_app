import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../core/constants/app_constants.dart';
import '../models/city_model.dart';

class LocalStorageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.favoriteCitiesTable}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');
  }


  Future<void> addFavoriteCity(String cityName) async {
    final db = await database;
    await db.insert(
      AppConstants.favoriteCitiesTable,
      {'name': cityName},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }


  Future<void> removeFavoriteCity(String cityName) async {
    final db = await database;
    await db.delete(
      AppConstants.favoriteCitiesTable,
      where: 'name = ?',
      whereArgs: [cityName],
    );
  }


  Future<List<CityModel>> getFavoriteCities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.favoriteCitiesTable,
    );
    return List.generate(maps.length, (i) => CityModel.fromMap(maps[i]));
  }


  Future<bool> isFavorite(String cityName) async {
    final db = await database;
    final result = await db.query(
      AppConstants.favoriteCitiesTable,
      where: 'name = ?',
      whereArgs: [cityName],
    );
    return result.isNotEmpty;
  }
}