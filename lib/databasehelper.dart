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

  // Function to update the required records
  Future<void> updateRecord(Map<String, dynamic> updatedRecord) async {
    final db = await database;

    // Update the record in the database table
    await db.update(
      'tyre_inventory', // Replace with your table name
      updatedRecord,
      where: 'id = ?', // Replace 'id' with your primary key column name
      whereArgs: [updatedRecord['id']],
    );
  }

  // Function to obtain the selling price
  Future<double> getSellingPriceById(int id) async {
    final db = await database;
    final result = await db.query(
      'tyre_inventory',
      columns: ['selling_price'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['selling_price'] as double;
    } else {
      // Return a default value or handle the case when the ID is not found
      return 0; // You can change this to your preferred default value
    }
  }

  Future<int> getQuantityById(int id) async {
    final db = await database;
    final result = await db.query(
      'tyre_inventory',
      columns: ['quantity'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['quantity'] as int;
    } else {
      // Return a default value or handle the case when the ID is not found
      return 0; // You can change this to your preferred default value
    }
  }

}
