class AuthResponseDto {
  final String accessToken;
  final String tokenType;

  AuthResponseDto({
    required this.accessToken,
    required this.tokenType
  });

  // Factory to create from JSON
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      accessToken: json['accessToken'],
      tokenType: json['tokenType']
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType
    };
  }
}