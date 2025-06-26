// lib/models/product_submission.dart
class ProductSubmission {
  final int? id;
  final int userId; // ID pengguna yang mengajukan produk
  final String userName; // Nama pengguna (opsional, untuk tampilan admin)
  final String title;
  final int price;
  final String company;
  final String image; // Path ke aset gambar yang diajukan
  final String description;
  final String status; // 'pending', 'approved', 'rejected'
  final String submissionDate; // Tanggal pengajuan

  ProductSubmission({
    this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.price,
    required this.company,
    required this.image,
    required this.description,
    this.status = 'pending', // Default status pending
    required this.submissionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'price': price,
      'company': company,
      'image': image,
      'description': description,
      'status': status,
      'submissionDate': submissionDate,
    };
  }

  factory ProductSubmission.fromMap(Map<String, dynamic> map) {
    return ProductSubmission(
      id: map['id'] as int,
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      title: map['title'] as String,
      price: map['price'] as int,
      company: map['company'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      submissionDate: map['submissionDate'] as String,
    );
  }

  ProductSubmission copyWith({
    int? id,
    int? userId,
    String? userName,
    String? title,
    int? price,
    String? company,
    String? image,
    String? description,
    String? status,
    String? submissionDate,
  }) {
    return ProductSubmission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      price: price ?? this.price,
      company: company ?? this.company,
      image: image ?? this.image,
      description: description ?? this.description,
      status: status ?? this.status,
      submissionDate: submissionDate ?? this.submissionDate,
    );
  }

  @override
  String toString() {
    return 'ProductSubmission(id: $id, userId: $userId, title: $title, status: $status)';
  }
}