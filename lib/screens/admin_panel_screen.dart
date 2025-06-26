import 'package:flutter/material.dart';
import 'package:final_project/screens/admin_product_management_screen.dart'; // Import file baru
import 'package:final_project/screens/admin_order_confirmation_screen.dart'; // Import file baru
import 'package:final_project/services/auth_manager.dart'; // Untuk logout
import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/screens/admin_submission_review_screen.dart'; // Import file baru

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Admin Panel', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthManager().logout(); // Hapus status login admin
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.redAccent),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang, Admin!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pilih tindakan manajemen di bawah:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              _buildAdminButton(
                context,
                'Kelola Produk Live', // Ubah teks untuk lebih jelas
                Icons.phone_android,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminProductManagementScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildAdminButton(
                context,
                'Review Pengajuan Produk', // Tombol baru
                Icons.check_circle_outline,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminSubmissionReviewScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildAdminButton(
                context,
                'Konfirmasi Pesanan',
                Icons.receipt_long,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminOrderConfirmationScreen()),
                  );
                },
              ),
              // Tambahkan lebih banyak tombol jika ada fungsionalitas admin lain
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton(
      BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow, // Warna tombol konsisten
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
    );
  }
}