// lib/services/product_submission_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:final_project/models/product_submission.dart';

class ProductSubmissionService {
  static final ProductSubmissionService _instance = ProductSubmissionService._internal();
  factory ProductSubmissionService() => _instance;

  static Database? _submissionDatabase;

  ProductSubmissionService._internal();

  Future<Database> get database async {
    if (_submissionDatabase != null) return _submissionDatabase!;
    _submissionDatabase = await _initDb();
    return _submissionDatabase!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'product_submissions.db'); // Database terpisah

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE product_submissions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        userName TEXT,
        title TEXT,
        price INTEGER,
        company TEXT,
        image TEXT,
        description TEXT,
        status TEXT,
        submissionDate TEXT
      )
    ''');
  }

  // CREATE Product Submission
  Future<int> addSubmission(ProductSubmission submission) async {
    final db = await database;
    return await db.insert('product_submissions', submission.toMap());
  }

  // READ Pending Submissions (untuk admin)
  Future<List<ProductSubmission>> getPendingSubmissions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'product_submissions',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'submissionDate DESC',
    );
    return List.generate(maps.length, (i) {
      return ProductSubmission.fromMap(maps[i]);
    });
  }

  // READ Submissions by User ID (untuk user melihat status pengajuannya)
  Future<List<ProductSubmission>> getSubmissionsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'product_submissions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'submissionDate DESC',
    );
    return List.generate(maps.length, (i) {
      return ProductSubmission.fromMap(maps[i]);
    });
  }

  // UPDATE Submission Status
  Future<int> updateSubmissionStatus(int id, String newStatus) async {
    final db = await database;
    return await db.update(
      'product_submissions',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE Submission
  Future<int> deleteSubmission(int id) async {
    final db = await database;
    return await db.delete(
      'product_submissions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Metode untuk membersihkan database pengajuan (hanya untuk debugging)
  Future<void> clearSubmissionDatabase() async {
    final db = await database;
    await db.delete('product_submissions');
  }
}