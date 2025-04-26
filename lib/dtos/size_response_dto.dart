class SizeResponseDto {
  late final int id;
  late final String size;
  late final int stock;

  SizeResponseDto({required this.id, required this.size, required this.stock});

  // Factory to create from JSON
  factory SizeResponseDto.fromJson(Map<String, dynamic> json) {
    return SizeResponseDto(
        id: json['id'], size: json['size'], stock: json['stock']);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'size': size, 'stock': stock};
  }
}
