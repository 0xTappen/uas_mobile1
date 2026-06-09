import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'uas_2431209.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE matakuliah_2431209 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kode_mk TEXT,
        nama_mk TEXT,
        sks INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE mahasiswa_2431209 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        npm TEXT,
        nama TEXT,
        prodi TEXT
      )
    ''');
  }

  Future<int> insertMahasiswa(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('mahasiswa_2431209', data);
  }

  Future<List<Map<String, dynamic>>> getMahasiswa() async {
    final db = await database;
    return db.query('mahasiswa_2431209', orderBy: 'id DESC');
  }

  Future<int> updateMahasiswa(int id, Map<String, dynamic> data) async {
    final db = await database;
    return db.update(
      'mahasiswa_2431209',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMahasiswa(int id) async {
    final db = await database;
    return db.delete('mahasiswa_2431209', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertMatakuliah(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('matakuliah_2431209', data);
  }

  Future<List<Map<String, dynamic>>> getMatakuliah() async {
    final db = await database;
    return db.query('matakuliah_2431209', orderBy: 'id DESC');
  }

  Future<int> updateMatakuliah(int id, Map<String, dynamic> data) async {
    final db = await database;
    return db.update(
      'matakuliah_2431209',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMatakuliah(int id) async {
    final db = await database;
    return db.delete('matakuliah_2431209', where: 'id = ?', whereArgs: [id]);
  }
}
