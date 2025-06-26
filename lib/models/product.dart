class Product {
  final int? id; // ID bisa null saat membuat produk baru (auto-increment)
  final int price;
  final String title;
  final String company;
  final String image; // Path ke aset gambar
  final String description;

  Product({
    this.id, // Jadikan nullable
    required this.price,
    required this.title,
    required this.company,
    required this.image,
    required this.description,
  });

  // Konversi Product object ke Map (untuk disimpan di database)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Biarkan null jika auto-increment oleh DB
      'price': price,
      'title': title,
      'company': company,
      'image': image,
      'description': description,
    };
  }

  // Konversi Map dari database ke Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int, // ID dari database tidak akan null
      price: map['price'] as int,
      title: map['title'] as String,
      company: map['company'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
    );
  }

  // Metode untuk kemudahan update
  Product copyWith({
    int? id,
    int? price,
    String? title,
    String? company,
    String? image,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      price: price ?? this.price,
      title: title ?? this.title,
      company: company ?? this.company,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, price: $price, company: $company, image: $image, description: $description)';
  }
}