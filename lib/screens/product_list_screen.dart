// lib/screens/product_list_screen.dart
import 'package:final_project/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/pages/product_detail_screen.dart';
import 'package:final_project/services/product_service.dart';
import 'package:final_project/screens/products.dart'; // Merujuk ke kelas Productss
import 'package:final_project/screens/about.dart';
import 'package:final_project/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:final_project/screens/user_add_product_screen.dart'; // Import UserAddProductScreen
import 'package:final_project/services/auth_manager.dart'; // Untuk logout
import 'dart:io'; // Import ini

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<String> imageListt = [
    'assets/apple.png',
    'assets/samsung.png',
    'assets/oppo.png',
    'assets/xiaomi.png',
  ];
  final List<String> texxt = [
    'Apple',
    'Samsung',
    'Oppo',
    'Xiaomi',
  ];

  final ProductService productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  late Future<List<Product>> _productsFuture;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadInitialProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<List<Product>> _loadInitialProducts() async {
    try {
      final products = await productService.getProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _filteredProducts = products;
        });
      }
      return products;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load initial products: $e')),
        );
      }
      rethrow;
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((product) => product.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Helper function untuk menampilkan gambar dari asset atau file
  Widget _buildProductImage(String imagePath, {double? height, double? width, BoxFit? fit}) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, height: height, width: width, fit: fit,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: height ?? 100, color: Colors.grey),);
    } else if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), height: height, width: width, fit: fit,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: height ?? 100, color: Colors.grey),);
    } else {
      return Icon(Icons.image_not_supported, size: height ?? 100, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isSearchFocused) {
          setState(() {
            _isSearchFocused = false;
          });
          _searchController.clear();
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
          toolbarHeight: 60,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: _isSearchFocused
              ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for products',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.mobile_friendly_sharp,
                          color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isSearchFocused = false;
                          });
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    autofocus: true,
                  ),
                )
              : Text(
                  'Second Store',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearchFocused = true;
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 0, 0, 0),
                      Color.fromARGB(255, 0, 0, 0),
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/back.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    'My Phones Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'times new roman',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(Icons.home, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'All Products',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(Icons.shopping_cart, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Productss()));
                },
              ),
              ListTile(
                title: Text(
                  'My Profile',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(Icons.person, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              ListTile(
                title: Text(
                  'Ajukan Produk',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(Icons.add_box, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserAddProductScreen()));
                },
              ),
              ListTile(
                title: Text(
                  'About us',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(Icons.info, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(Icons.logout, color: Colors.white),
                onTap: () {
                  AuthManager().logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.yellow));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error loading products: ${snapshot.error}',
                            style: TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No products available.',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 280,
                            width: 500,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset( // Gambar banner utama tetap dari assets
                                'assets/mobile.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 220,
                            child: _filteredProducts.isEmpty && _searchController.text.isNotEmpty
                                ? Center(
                                    child: Text(
                                      'No products found matching your search.',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _filteredProducts.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      Product product = _filteredProducts[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailScreen(product: product),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 200,
                                          margin: EdgeInsets.only(right: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  // Gunakan helper function untuk gambar produk
                                                  child: _buildProductImage(product.image, fit: BoxFit.cover),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                product.title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '\$${product.price.toString()}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            color: Color.fromARGB(255, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Top Brand',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 251, 0),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 145,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageListt.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Logika filter berdasarkan merek bisa ditambahkan di sini
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(14),
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          height: 114.0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(50),
                                                child: Image.asset( // Gambar merek tetap dari assets
                                                  imageListt[index],
                                                  fit: BoxFit.cover,
                                                  height: 80,
                                                  width: 80,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                texxt[index % texxt.length],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'times new roman',
                                                  color: Color.fromARGB(255, 255, 255, 255),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}