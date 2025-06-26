class Order {
  final int? id;
  final int userId; // ID pengguna yang membuat pesanan
  final int productId; // ID produk yang dipesan
  final int quantity;
  final String status; // 'pending', 'confirmed', 'rejected', 'delivered'
  final String orderDate; // Tanggal pesanan (contoh: 'YYYY-MM-DD HH:MM:SS')

  Order({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.status = 'pending', // Default status
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'status': status,
      'orderDate': orderDate,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      userId: map['userId'] as int,
      productId: map['productId'] as int,
      quantity: map['quantity'] as int,
      status: map['status'] as String,
      orderDate: map['orderDate'] as String,
    );
  }

  Order copyWith({
    int? id,
    int? userId,
    int? productId,
    int? quantity,
    String? status,
    String? orderDate,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, userId: $userId, productId: $productId, quantity: $quantity, status: $status, orderDate: $orderDate)';
  }
}