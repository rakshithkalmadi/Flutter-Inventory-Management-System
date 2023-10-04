import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'your_database.db');

    return await openDatabase(
      path,
      version: 1, // You can change the database version if needed
      onCreate: (Database db, int version) async {
        // Create the table
        await db.execute('''
          CREATE TABLE your_table (
            id INTEGER PRIMARY KEY,
            brand TEXT,
            design TEXT,
            size TEXT,
            supplier TEXT,
            warehouse_section TEXT,
            cost_price REAL,
            selling_price REAL,
            quantity INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    await db.insert('your_table', record,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query('your_table');
  }
}
