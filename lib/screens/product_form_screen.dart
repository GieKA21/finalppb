import 'package:flutter/material.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/services/product_service.dart';
import 'package:image_picker/image_picker.dart'; // Import ini
import 'dart:io'; // Import ini untuk kelas File
import 'package:path_provider/path_provider.dart'; // Import ini
import 'package:path/path.dart' as p; // Import ini untuk path manipulation

class ProductFormScreen extends StatefulWidget {
  final Product? product; // Jika null, mode 'Tambah', jika ada, mode 'Edit'

  const ProductFormScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _companyController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage; // Untuk menyimpan gambar yang akan diupload/digunakan

  final ProductService _productService = ProductService();

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toString();
      _companyController.text = widget.product!.company;
      _descriptionController.text = widget.product!.description;

      // Inisialisasi _selectedImage jika ada gambar dari produk yang diedit
      if (widget.product!.image.startsWith('assets/')) {
        // Ini adalah aset, tidak bisa di-preview sebagai File
        _imageController.text = widget.product!.image; // Tampilkan path asset
      } else {
        final imageFile = File(widget.product!.image);
        if (imageFile.existsSync()) {
          _selectedImage = imageFile;
          _imageController.text = widget.product!.image; // Tampilkan path file lengkap
        } else {
          _imageController.text = 'Gambar tidak ditemukan'; // Handle jika file tidak ada
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _companyController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar dari galeri (mirip di UserAddProductScreen)
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageController.text = p.basename(pickedFile.path); // Nama file untuk feedback UI
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
          _selectedImage = null;
          _imageController.clear();
        });
      }
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan untuk gambar
      String imagePathToSave = '';
      if (_selectedImage != null) {
        imagePathToSave = _selectedImage!.path;
      } else if (_imageController.text.startsWith('assets/')) {
        imagePathToSave = _imageController.text; // Jika ini adalah path asset lama
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih gambar produk.')),
        );
        return;
      }


      final productToSave = Product(
        id: _isEditing ? widget.product!.id : null,
        title: _titleController.text,
        price: int.parse(_priceController.text),
        company: _companyController.text,
        image: imagePathToSave, // Gunakan path gambar yang ditentukan
        description: _descriptionController.text,
      );

      try {
        if (_isEditing) {
          await _productService.updateProduct(productToSave);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil diperbarui!')),
          );
        } else {
          await _productService.addProduct(productToSave);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan!')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan produk: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Produk' : 'Tambah Produk Baru',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Area untuk menampilkan gambar yang dipilih atau gambar produk yang ada
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
                  : (_isEditing && widget.product!.image.startsWith('assets/'))
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            widget.product!.image,
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
                label: Text('Pilih/Ubah Gambar dari Galeri', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              // Field untuk menampilkan path gambar (tidak bisa diedit manual)
              TextFormField(
                controller: _imageController,
                readOnly: true, // Tidak bisa diedit manual
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Jalur Gambar Produk (Otomatis terisi)',
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
                  // Validasi gambar: jika mode edit dan bukan aset, cek _selectedImage atau imageController
                  if (_isEditing && !widget.product!.image.startsWith('assets/')) {
                    if (_selectedImage == null && (value == null || value.isEmpty)) {
                      return 'Mohon pilih atau pertahankan gambar';
                    }
                  } else if (!_isEditing && _selectedImage == null) {
                    return 'Mohon pilih gambar produk';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(_titleController, 'Judul Produk', Icons.label),
              const SizedBox(height: 20),
              _buildTextField(_priceController, 'Harga', Icons.attach_money,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildTextField(
                  _companyController, 'Perusahaan', Icons.business),
              const SizedBox(height: 20),
              _buildTextField(
                _descriptionController,
                'Deskripsi',
                Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                ),
                child: Text(
                  _isEditing ? 'Perbarui Produk' : 'Tambah Produk',
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