import 'package:flutter/material.dart';
import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/screens/product_list_screen.dart';
import 'package:final_project/screens/admin_panel_screen.dart';
import 'package:final_project/services/auth_manager.dart'; // Import AuthManager

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager().loadUser(); // Load user session on app start
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Phones Store',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Cek status login saat aplikasi pertama kali dimuat
        future: AuthManager().loadUser(), // Memastikan user data dimuat
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final authManager = AuthManager();
            if (authManager.currentUserId != null) {
              // Jika ada user yang login
              if (authManager.isAdmin == true) {
                return const AdminPanelScreen();
              } else {
                return ProductListScreen();
              }
            } else {
              // Jika tidak ada user yang login
              return const LoginScreen();
            }
          }
          // Tampilkan loading screen sementara
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.yellow)),
          );
        },
      ),
    );
  }
}

// MainScreen sebelumnya yang merupakan splash screen, bisa diubah
// atau dihapus jika Anda langsung ingin ke LoginScreen atau ProductListScreen.
// Saya mengubah `home` di `MyApp` untuk langsung menentukan layar berdasarkan status login.
// Jika Anda masih ingin splash screen, Anda bisa membuat MainScreen sebagai splash screen
// yang kemudian menavigasi ke layar yang tepat setelah delay/animasi selesai.

// Ini adalah contoh MainScreen jika Anda ingin tetap mempertahankannya sebagai splash screen
// yang kemudian akan mengecek login
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _buttonOffsetAnimation;
  late Animation<Offset> _textOffsetAnimation;
  // bool _isTextAnimated = false; // Tidak digunakan untuk logika di bawah

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _buttonOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    _textOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SlideTransition(
                position: _textOffsetAnimation,
                child: const Text(
                  'My Phones Store',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'times new roman'),
                ),
              ),
              const SizedBox(height: 50),
              SlideTransition(
                position: _textOffsetAnimation,
                child: Text(
                  'Lets start with my amazing app and buy your favourite phone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                    fontFamily: 'arial',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SlideTransition(
                position: _buttonOffsetAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    elevation: 5.0,
                    textStyle: const TextStyle(fontSize: 20.0),
                    minimumSize: const Size(300.0, 60.0),
                  ),
                  child: const Text(
                    'Get Start',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                        fontFamily: 'arial'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}