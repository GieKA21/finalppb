import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/services/order_service.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/services/auth_manager.dart';
import 'dart:io'; // Import ini

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  // Helper function baru untuk mengembalikan ImageProvider
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else if (File(imagePath).existsSync()) {
      return FileImage(File(imagePath));
    } else {
      // Sebagai fallback, kembalikan placeholder jika gambar tidak ditemukan/valid
      // Anda bisa menggunakan asset placeholder atau ImageProvider dari network jika ada
      // Untuk tujuan ini, kita bisa menggunakan asset placeholder
      return AssetImage('assets/placeholder.png'); // Pastikan Anda memiliki gambar placeholder ini
                                                // atau sesuaikan dengan aset default Anda.
                                                // Jika tidak ada, ini bisa jadi crash lagi.
                                                // Atau cukup return AssetImage('assets/mobile.png'); sebagai default.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          product.title,
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                // LANGSUNG GUNAKAN _getImageProvider DI SINI
                image: DecorationImage(
                  image: _getImageProvider(product.image), // Hapus .image tambahan di sini
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 251, 0)),
                    ),
                    Text(
                      '\Price: \$${product.price}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 251, 0)),
                    ),
                    Text(
                      product.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final userId = AuthManager().currentUserId;
                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Anda harus login untuk membeli produk.')),
                          );
                          return;
                        }

                        final orderService = OrderService();
                        final newOrder = Order(
                          userId: userId,
                          productId: product.id!,
                          quantity: 1,
                          orderDate: DateTime.now().toIso8601String(),
                          status: 'pending',
                        );

                        try {
                          final orderId = await orderService.addOrder(newOrder);
                          if (orderId > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Produk berhasil ditambahkan ke pesanan. Menunggu konfirmasi admin.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gagal menambahkan produk ke pesanan.')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Terjadi kesalahan: $e')),
                          );
                        }
                      },
                      child: Text(
                        'Buy Now',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 243, 220, 11),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}