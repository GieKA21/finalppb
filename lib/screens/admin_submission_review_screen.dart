import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/models/product_submission.dart';
import 'package:final_project/services/product_submission_service.dart';
import 'package:final_project/services/product_service.dart';
import 'dart:io'; // Import ini

class AdminSubmissionReviewScreen extends StatefulWidget {
  const AdminSubmissionReviewScreen({Key? key}) : super(key: key);

  @override
  _AdminSubmissionReviewScreenState createState() => _AdminSubmissionReviewScreenState();
}

class _AdminSubmissionReviewScreenState extends State<AdminSubmissionReviewScreen> {
  final ProductSubmissionService _submissionService = ProductSubmissionService();
  final ProductService _productService = ProductService();

  late Future<List<ProductSubmission>> _pendingSubmissionsFuture;

  @override
  void initState() {
    super.initState();
    _refreshSubmissions();
  }

  void _refreshSubmissions() {
    setState(() {
      _pendingSubmissionsFuture = _submissionService.getPendingSubmissions();
    });
  }

  Future<void> _approveSubmission(ProductSubmission submission) async {
    try {
      final newProduct = Product(
        id: null,
        title: submission.title,
        price: submission.price,
        company: submission.company,
        image: submission.image, // Gunakan image path dari submission
        description: submission.description,
      );
      await _productService.addProduct(newProduct);

      await _submissionService.deleteSubmission(submission.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dikonfirmasi dan ditayangkan!')),
      );
      _refreshSubmissions();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengkonfirmasi produk: $e')),
      );
      print('Error approving submission: $e');
    }
  }

  Future<void> _rejectSubmission(int submissionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Penolakan'),
        content: Text('Apakah Anda yakin ingin menolak pengajuan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Tolak', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _submissionService.deleteSubmission(submissionId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengajuan berhasil ditolak dan dihapus.')),
        );
        _refreshSubmissions();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menolak pengajuan: $e')),
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
      return Icon(Icons.image_not_supported, size: height ?? 70, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Review Pengajuan Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ProductSubmission>>(
        future: _pendingSubmissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Tidak ada pengajuan produk tertunda.',
                    style: TextStyle(color: Colors.white)));
          } else {
            final submissions = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final submission = submissions[index];
                return Card(
                  color: Color.fromARGB(255, 56, 53, 53),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diajukan oleh: ${submission.userName}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Tanggal Pengajuan: ${submission.submissionDate.substring(0, 10)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const Divider(color: Colors.white38),
                        Row(
                          children: [
                            // Gunakan helper function untuk gambar
                            _buildProductImage(submission.image, width: 70, height: 70, fit: BoxFit.cover),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    submission.title,
                                    style: const TextStyle(
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    'Harga: \$${submission.price}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Perusahaan: ${submission.company}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Deskripsi: ${submission.description}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _approveSubmission(submission),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('Setuju', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _rejectSubmission(submission.id!),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Tolak', style: TextStyle(color: Colors.white)),
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