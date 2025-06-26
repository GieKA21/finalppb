import 'package:flutter/material.dart';
import 'package:final_project/screens/product_list_screen.dart';
import 'package:final_project/screens/admin_panel_screen.dart';
import 'package:final_project/screens/register_screen.dart';
import 'package:final_project/services/database_helper.dart'; // Import DatabaseHelper
import 'package:final_project/models/user.dart'; // Import model User
import 'package:final_project/screens/forgot_password_screen.dart';
import 'package:final_project/services/auth_manager.dart'; // Import AuthManager

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthManager _authManager = AuthManager(); // Instance AuthManager

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      print('Attempting login for: Email: $email, Password: $password');

      // --- LOGIKA LOGIN ADMIN (Hardcoded - PERHATIAN KRITIS: TIDAK AMAN UNTUK PRODUKSI) ---
      if (email == 'admin@example.com' && password == 'admin') {
        _authManager.login(0, email, 'Admin'); // ID 0 untuk admin, email admin, nama 'Admin'
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Admin Berhasil!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
        );
        return;
      }
      // --- AKHIR LOGIKA LOGIN ADMIN ---

      // --- LOGIKA LOGIN PENGGUNA DARI SQLITE ---
      User? loggedInUser = await _dbHelper.loginUser(email, password);

      if (loggedInUser != null) {
        _authManager.login(loggedInUser.id!, loggedInUser.email, loggedInUser.fullName); // Simpan ID user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Pengguna Berhasil!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductListScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau Password salah.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'My Phones Store',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'times new roman',
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Input Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Input Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Tombol Login
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 20),

                      // Lupa Password?
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                              color:
                                  Colors.white70), // Sesuaikan warna teks Anda
                        ),
                      ),

                      // Belum punya akun? Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun?',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigasi ke halaman Register
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 251, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}