import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;

  AuthManager._internal();

  int? _currentUserId;
  String? _currentUserEmail;
  String? _currentUserName;
  bool? _isAdmin;

  int? get currentUserId => _currentUserId;
  String? get currentUserEmail => _currentUserEmail;
  String? get currentUserName => _currentUserName;
  bool? get isAdmin => _isAdmin;


  // Load user data from SharedPreferences when the app starts
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('userId');
    _currentUserEmail = prefs.getString('userEmail');
    _currentUserName = prefs.getString('userName');
    _isAdmin = prefs.getBool('isAdmin') ?? false;
    print('AuthManager loaded user: ID=$_currentUserId, Email=$_currentUserEmail, Name=$_currentUserName, Admin=$_isAdmin');
  }

  // Save user data to SharedPreferences after successful login
  Future<void> login(int id, String email, String name, {bool isAdmin = false}) async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = id;
    _currentUserEmail = email;
    _currentUserName = name;
    _isAdmin = isAdmin;

    await prefs.setInt('userId', id);
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
    await prefs.setBool('isAdmin', isAdmin);
    print('AuthManager logged in user: ID=$id, Email=$email, Name=$name, Admin=$isAdmin');
  }

  // Clear user data from SharedPreferences after logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = null;
    _currentUserEmail = null;
    _currentUserName = null;
    _isAdmin = null;
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('isAdmin');
    print('AuthManager logged out.');
  }
}