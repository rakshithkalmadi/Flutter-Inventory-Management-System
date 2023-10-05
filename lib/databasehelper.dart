import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
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

  //Initialize the database
  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'inventory.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the table
        await db.execute('''
          CREATE TABLE tyre_inventory (
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

  // Function to insert a record into table
  Future<void> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    await db.insert('tyre_inventory', record,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Function to retrieve the records from the table
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query('tyre_inventory');
  }

  // Function to update the quantity
  Future<void> updateQuantity(int id, int newQuantity) async {
    final db = await database;
    await db.update(
      'tyre_inventory',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
