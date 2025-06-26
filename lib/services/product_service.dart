import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:final_project/models/product.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  static Database? _productDatabase;

  ProductService._internal();

  Future<Database> get database async {
    if (_productDatabase != null) return _productDatabase!;
    _productDatabase = await _initDb();
    return _productDatabase!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'products.db'); // Database terpisah untuk produk

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        price INTEGER,
        title TEXT,
        company TEXT,
        image TEXT,
        description TEXT
      )
    ''');
    // Tambahkan data awal jika database kosong (opsional, bisa juga via UI admin)
    // Ini menggantikan data hardcoded di getProducts sebelumnya
    await db.insert('products', Product(id: null, price: 499, title: 'iPhone 8', company: 'Apple', image: 'assets/iphone8.png', description: 'The iPhone 8 features a 4.7-inch display...').toMap());
    await db.insert('products', Product(id: null, price: 899, title: 'Samsung Galaxy S21', company: 'Samsung', image: 'assets/samsung21.png', description: 'The Galaxy S21 has a screen size of 6.2 inches...').toMap());
    await db.insert('products', Product(id: null, price: 899, title: 'iPhone 12', company: 'Apple', image: 'assets/iphone12.png', description: 'The iPhone 12 Mini features a 5.4-inch...').toMap());
    await db.insert('products', Product(id: null, price: 799, title: 'iPhone 13', company: 'Apple', image: 'assets/iphone13.png', description: 'The iPhone 13 mini display has rounded corners...').toMap());
    await db.insert('products', Product(id: null, price: 699, title: 'iPhone X', company: 'Apple', image: 'assets/iphonex.png', description: 'The iPhone X display has rounded corners...').toMap());
    await db.insert('products', Product(id: null, price: 999, title: 'Samsung Galaxy S20', company: 'Samsung', image: 'assets/samsung20.png', description: 'The Galaxy S20 has a screen size of 6.2 inches...').toMap());
    await db.insert('products', Product(id: null, price: 799, title: 'iPhone 11', company: 'Apple', image: 'assets/iphone11.png', description: 'The iPhone 11 has a 6.1-inch...').toMap());
    await db.insert('products', Product(id: null, price: 999, title: 'Samsung Galaxy Note 20 Ultra', company: 'Samsung', image: 'assets/samsungnote.png', description: 'The Note 20 and Note 20 Ultra feature a 6.7-inch...').toMap());
  }

  Future<int> addProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearProductDatabase() async {
    final db = await database;
    await db.delete('products');
  }
}