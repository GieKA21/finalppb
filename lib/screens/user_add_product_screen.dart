import 'package:flutter/material.dart';
import 'package:final_project/models/product_submission.dart';
import 'package:final_project/services/product_submission_service.dart';
import 'package:final_project/services/auth_manager.dart';
import 'package:image_picker/image_picker.dart'; // Import ini
import 'dart:io'; // Import ini untuk kelas File
import 'package:path_provider/path_provider.dart'; // Import ini
import 'package:path/path.dart' as p; // Import ini untuk path manipulation

class UserAddProductScreen extends StatefulWidget {
  const UserAddProductScreen({Key? key}) : super(key: key);

  @override
  _UserAddProductScreenState createState() => _UserAddProductScreenState();
}

class _UserAddProductScreenState extends State<UserAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _companyController = TextEditingController();
  // _imageController akan menampilkan path gambar yang dipilih/disimpan
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage; // Variabel untuk menyimpan file gambar yang dipilih

  final ProductSubmissionService _submissionService = ProductSubmissionService();
  final AuthManager _authManager = AuthManager();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _companyController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar dari galeri dan menyimpannya secara lokal
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        // Tampilkan nama file di controller, atau path sementara
        _imageController.text = p.basename(pickedFile.path); // Hanya nama file untuk feedback UI
      });

      // Simpan gambar ke direktori aplikasi secara permanen
      try {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = p.basename(pickedFile.path);
        final String newPath = p.join(directory.path, fileName);
        final File newImage = await _selectedImage!.copy(newPath);

        setState(() {
          _selectedImage = newImage;
          _imageController.text = newImage.path; // Simpan path lengkap untuk database
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil dipilih dan disimpan lokal!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan gambar: $e')),
        );
        setState(() {
          _selectedImage = null; // Reset jika gagal
          _imageController.clear();
        });
      }
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih gambar produk terlebih dahulu.')),
        );
        return;
      }

      final userId = _authManager.currentUserId;
      final userName = _authManager.currentUserName;

      if (userId == null || userName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda harus login untuk mengajukan produk.')),
        );
        return;
      }

      final newSubmission = ProductSubmission(
        userId: userId,
        userName: userName,
        title: _titleController.text,
        price: int.parse(_priceController.text),
        company: _companyController.text,
        image: _selectedImage!.path, // Gunakan path gambar yang disimpan
        description: _descriptionController.text,
        status: 'pending', // Status awal
        submissionDate: DateTime.now().toIso8601String(),
      );

      try {
        final id = await _submissionService.addSubmission(newSubmission);
        if (id > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil diajukan! Menunggu konfirmasi admin.')),
          );
          Navigator.pop(context); // Kembali ke layar sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengajukan produk. Coba lagi.')),
          );
        }
      } catch (e) {
        print('Error submitting product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Ajukan Produk Baru', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Area untuk menampilkan gambar yang dipilih
              _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Icon(Icons.image, size: 80, color: Colors.white54),
                    ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library, color: Colors.black),
                label: Text('Pilih Gambar dari Galeri', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              // Field untuk menampilkan path gambar (tidak perlu diisi manual)
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageController,
                readOnly: true, // Tidak bisa diedit manual
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Jalur Gambar (Otomatis terisi)',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.folder, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.yellow),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || _selectedImage == null) {
                    return 'Gambar produk harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(_titleController, 'Judul Produk', Icons.label),
              const SizedBox(height: 20),
              _buildTextField(_priceController, 'Harga (Rp)', Icons.attach_money,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildTextField(
                  _companyController, 'Perusahaan (Contoh: Apple, Samsung)', Icons.business),
              const SizedBox(height: 20),
              _buildTextField(
                _descriptionController,
                'Deskripsi Produk',
                Icons.description,
                maxLines: 5,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                ),
                child: const Text(
                  'Ajukan Produk',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText tidak boleh kosong';
        }
        if (keyboardType == TextInputType.number) {
          if (int.tryParse(value) == null) {
            return 'Masukkan angka yang valid untuk $labelText';
          }
        }
        return null;
      },
    );
  }
}