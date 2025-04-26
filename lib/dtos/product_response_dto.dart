import 'package:shopping_app/dtos/size_response_dto.dart';

class ProductResponseDto {
  late final int id;
  late final String name;
  late final String details;
  late final String imageUrl;
  late final double price;
  late final int categoryId;
  late final List<SizeResponseDto> sizes;
  late final bool trending;
  late final bool bestSelling;

  ProductResponseDto({
    required this.id,
    required this.name,
    required this.details,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
    required this.sizes,
    required this.trending,
    required this.bestSelling,
  });

  // Factory to create from JSON
  factory ProductResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductResponseDto(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      categoryId: json['categoryId'],
      sizes: (json['sizes'] as List)
          .map((sizeJson) => SizeResponseDto.fromJson(sizeJson))
          .toList(),
      trending: json['trending'],
      bestSelling: json['bestSelling'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'imageUrl': imageUrl,
      'price': price,
      'categoryId': categoryId,
      'sizes': sizes,
      'trending': trending,
      'bestSelling': bestSelling,
    };
  }
}
