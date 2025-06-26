class User {
  final int? id; // id bisa null saat membuat user baru (auto-increment)
  final String fullName;
  final String email;
  final String password; // Penting: Di aplikasi nyata, password harus di-hash sebelum disimpan!

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
  });

  // Konversi User object ke Map (untuk disimpan di database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
    };
  }

  // Konversi Map dari database ke User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  // Tambahkan metode ini untuk kemudahan update
  User copyWith({
    int? id,
    String? fullName,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, email: $email, password: [HIDDEN])'; // Sembunyikan password di toString
  }
}