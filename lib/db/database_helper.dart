import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static late Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath!, 'games.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS games (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player1 TEXT,
            player2 TEXT,
            result TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertGame(String player1, String player2, String result) async {
    final db = await database;
    await db.insert(
      'games',
      {
        'player1': player1,
        'player2': player2,
        'result': result,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}