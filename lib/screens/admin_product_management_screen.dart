import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/services/product_service.dart';
import 'package:final_project/screens/product_form_screen.dart';
import 'dart:io'; // Import ini

class AdminProductManagementScreen extends StatefulWidget {
  const AdminProductManagementScreen({Key? key}) : super(key: key);

  @override
  _AdminProductManagementScreenState createState() =>
      _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState extends State<AdminProductManagementScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  void _refreshProductList() {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  Future<void> _deleteProduct(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _productService.deleteProduct(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus!')),
        );
        _refreshProductList();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus produk: $e')),
        );
      }
    }
  }

  // Helper function untuk menampilkan gambar dari asset atau file
  Widget _buildProductImage(String imagePath, {double? height, double? width, BoxFit? fit}) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, height: height, width: width, fit: fit);
    } else if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), height: height, width: width, fit: fit);
    } else {
      return Icon(Icons.image_not_supported, size: height ?? 80, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text('Manajemen Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductFormScreen(product: null)),
              );
              _refreshProductList();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Belum ada produk.',
                    style: TextStyle(color: Colors.white)));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Color.fromARGB(255, 56, 53, 53),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Gunakan helper function untuk gambar
                        _buildProductImage(product.image, width: 80, height: 80, fit: BoxFit.cover),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                'Harga: \$${product.price}',
                                style:
                                    const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                'Perusahaan: ${product.company}',
                                style:
                                    const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                'Deskripsi: ${product.description}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.yellow),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductFormScreen(product: product)),
                                );
                                _refreshProductList();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(product.id!),
                            ),
                          ],
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
    );
  }
}