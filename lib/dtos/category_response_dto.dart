class CategoryResponseDto {
  int? id;
  late final String name;

  CategoryResponseDto({
    this.id,
    required this.name,
  });

  // Factory to create from JSON
  factory CategoryResponseDto.fromJson(Map<String, dynamic> json) {
    return CategoryResponseDto(
      id: json['id'],
      name: json['name'],
    );
  }
}
