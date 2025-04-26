class CartResponseDto {
  int? id;
  String? size;
  late final double price;
  late final int productId;
  late final int qty;
  late final double totalAmount;
  late final String imageUrl;
  late final String productName;

  CartResponseDto({
    this.id,
    required this.size,
    required this.price,
    required this.productId,
    required this.qty,
    required this.totalAmount,
    required this.imageUrl,
    required this.productName,
  });

  // Factory to create from JSON
  factory CartResponseDto.fromJson(Map<String, dynamic> json) {
    return CartResponseDto(
      id: json['id'],
      size: json['size'],
      price: json['price'],
      productId: json['productId'],
      qty: json['qty'],
      totalAmount: json['totalAmount'],
      imageUrl: json['imageUrl'],
      productName: json['productName'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'price': price,
      'productId': productId,
      'qty': qty,
      'totalAmount': totalAmount,
      'imageUrl': imageUrl,
      'productName': productName,
    };
  }
}
