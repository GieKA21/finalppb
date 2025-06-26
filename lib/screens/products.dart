import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/pages/product_detail_screen.dart';
import 'package:final_project/services/product_service.dart';
import 'dart:io'; // Import ini

class Productss extends StatefulWidget {
  const Productss({Key? key});

  @override
  _Productss createState() => _Productss();
}

class _Productss extends State<Productss> {
  final ProductService productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = productService.getProducts(); // Sudah benar inisialisasi di sini
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Text('All Products', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Semua Tipe HP Ada Lohh..',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Bebas Pilih Wakk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.yellow));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No products available.", style: TextStyle(color: Colors.white)));
                } else {
                  List<Product> products = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      Product product = products[index];
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
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 56, 53, 53),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                // Gunakan helper function untuk gambar produk
                                child: _buildProductImage(product.image, width: 100, height: 100, fit: BoxFit.cover),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                    SizedBox(height: 10),
                                    Text(
                                      product.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}