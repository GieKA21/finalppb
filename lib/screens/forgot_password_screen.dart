import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form
  bool _isLoading = false; // Untuk menampilkan loading indicator

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Fungsi untuk mensimulasikan pengiriman email reset password
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mulai loading
      });

      // Simulasikan penundaan pengiriman email
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false; // Selesai loading
      });

      // Tampilkan pesan sukses atau error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tautan pengaturan ulang kata sandi telah dikirim ke ${_emailController.text}.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Opsional: Kembali ke layar login setelah beberapa detik
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pop(context); // Kembali ke layar sebelumnya (login)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam konsisten
      appBar: AppBar(
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon kembali
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Masukkan alamat email Anda untuk menerima tautan pengaturan ulang kata sandi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    hintText: 'contoh@email.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.yellow), // Warna fokus
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
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.yellow)) // Loading indicator
                    : ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow, // Warna tombol konsisten
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5.0,
                        ),
                        child: const Text(
                          'Kirim Tautan Reset',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke layar login
                  },
                  child: const Text(
                    'Kembali ke Login',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}