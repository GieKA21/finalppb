import 'package:flutter/material.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/services/order_service.dart';
import 'package:final_project/services/product_service.dart';
import 'package:final_project/services/database_helper.dart';
import 'dart:io';

class AdminOrderConfirmationScreen extends StatefulWidget {
  const AdminOrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  _AdminOrderConfirmationScreenState createState() =>
      _AdminOrderConfirmationScreenState();
}

class _AdminOrderConfirmationScreenState extends State<AdminOrderConfirmationScreen> {
  final OrderService _orderService = OrderService();
  final ProductService _productService = ProductService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late Future<List<Order>> _pendingOrdersFuture;

  @override
  void initState() {
    super.initState();
    _refreshPendingOrders();
  }

  void _refreshPendingOrders() {
    setState(() {
      _pendingOrdersFuture = _orderService.getAllPendingOrders();
    });
  }

  // Metode yang diperbarui untuk mengubah status pesanan DAN menghapus produk jika dikonfirmasi
  Future<void> _updateOrderStatus(Order order, String newStatus) async { // Menerima objek Order
    try {
      // Perbarui status pesanan di database
      await _orderService.updateOrderStatus(order.id!, newStatus);

      // Jika pesanan dikonfirmasi, hapus produknya
      if (newStatus == 'confirmed') {
        final productId = order.productId;
        final deletedRows = await _productService.deleteProduct(productId);
        if (deletedRows > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil dihapus dari stok!')),
          );
        } else {
          // Kasus jika produk tidak ditemukan (mungkin sudah dihapus sebelumnya)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk tidak ditemukan di stok atau sudah dihapus.')),
          );
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Pesanan berhasil di${newStatus.toLowerCase()}!')),
      );
      _refreshPendingOrders(); // Refresh daftar pesanan setelah perubahan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status pesanan: $e')),
      );
      print('Error updating order status or deleting product: $e'); // Log error untuk debugging
    }
  }

  Widget _buildProductImage(String imagePath, {double? height, double? width, BoxFit? fit}) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, height: height, width: width, fit: fit,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: height ?? 70, color: Colors.grey),);
    } else if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), height: height, width: width, fit: fit,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: height ?? 70, color: Colors.grey),);
    } else {
      return Icon(Icons.image_not_supported, size: height ?? 70, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Order>>(
        future: _pendingOrdersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Tidak ada pesanan tertunda.',
                    style: TextStyle(color: Colors.white)));
          } else {
            final pendingOrders = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final order = pendingOrders[index];
                return FutureBuilder<Map<String, dynamic>>(
                  // Mengambil detail produk dan user untuk setiap order
                  future: Future.wait([
                    _productService.getProductById(order.productId),
                    _dbHelper.getUserById(order.userId),
                  ]).then((results) => {
                        'product': results[0] as Product?,
                        'user': results[1] as User?,
                      }),
                  builder: (context, detailSnapshot) {
                    if (detailSnapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator(color: Colors.yellow);
                    } else if (detailSnapshot.hasError) {
                      return Text('Error loading details: ${detailSnapshot.error}', style: TextStyle(color: Colors.red));
                    } else {
                      final product = detailSnapshot.data!['product'] as Product?;
                      final user = detailSnapshot.data!['user'] as User?;

                      return Card(
                        color: Color.fromARGB(255, 56, 53, 53),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pesanan ID: ${order.id}',
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text('Produk: ${product?.title ?? 'Produk tidak ditemukan'}',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Kuantitas: ${order.quantity}',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Pembeli: ${user?.fullName ?? 'User tidak ditemukan'} (${user?.email ?? ''})',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Tanggal Pesan: ${order.orderDate.substring(0, 10)}',
                                  style: const TextStyle(color: Colors.white70)),
                              Text('Status: ${order.status.toUpperCase()}',
                                  style: TextStyle(color: order.status == 'pending' ? Colors.orange : Colors.green)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _updateOrderStatus(order, 'confirmed'), // Passing objek Order
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    child: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => _updateOrderStatus(order, 'rejected'), // Passing objek Order
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}