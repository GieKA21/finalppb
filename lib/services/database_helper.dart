import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:final_project/models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_phones_store.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
    // Catatan: Jika Anda juga mengelola produk di DB ini,
    // buat tabel products di sini juga. Tapi saat ini ProductService
    // punya DB sendiri.
    // Jika Anda ingin membersihkan dan memulai ulang database saat pengembangan,
    // Anda bisa menambah db.execute('DROP TABLE IF EXISTS users'); di sini.
  }

  // Metode untuk mendaftarkan pengguna baru
  Future<int> registerUser(User user) async {
    final db = await database;
    // Menggunakan insert untuk menambahkan user baru.
    // Jika email sudah terdaftar, ini akan gagal karena UNIQUE constraint pada email.
    // Error handling harus dilakukan di UI (RegisterScreen).
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort, // Lebih cocok untuk register
    );
  }

  // Metode untuk mencari pengguna berdasarkan email dan password
  Future<User?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?', // PENTING: Password di sini masih plain text
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Metode untuk mendapatkan semua pengguna (untuk debugging/admin, atau cek email duplikat)
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Metode untuk mendapatkan user berdasarkan ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Metode untuk memperbarui user
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Metode untuk membersihkan database (hanya untuk debugging)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
  }
}