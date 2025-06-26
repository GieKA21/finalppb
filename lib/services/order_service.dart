import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:final_project/models/order.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;

  static Database? _orderDatabase;

  OrderService._internal();

  Future<Database> get database async {
    if (_orderDatabase != null) return _orderDatabase!;
    _orderDatabase = await _initDb();
    return _orderDatabase!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'orders.db'); // Database terpisah untuk pesanan

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        productId INTEGER,
        quantity INTEGER,
        status TEXT,
        orderDate TEXT
      )
    ''');
  }

  // CREATE Order
  Future<int> addOrder(Order order) async {
    final db = await database;
    return await db.insert('orders', order.toMap());
  }

  // READ Orders by User ID (untuk melihat riwayat pesanan user)
  Future<List<Order>> getOrdersByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'orderDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  // READ All Pending Orders (untuk admin)
  Future<List<Order>> getAllPendingOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'orderDate DESC',
    );
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  // UPDATE Order Status
  Future<int> updateOrderStatus(int orderId, String newStatus) async {
    final db = await database;
    return await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  // DELETE Order (opsional, mungkin hanya admin yang bisa)
  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Metode untuk membersihkan database order (hanya untuk debugging)
  Future<void> clearOrderDatabase() async {
    final db = await database;
    await db.delete('orders');
  }
}