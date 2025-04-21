class AuthResponseDto {
  String? accessToken;
  String? tokenType;
  int? id;
  String? firstName;
  String? email;
  String? username;

  AuthResponseDto({
    required this.accessToken,
    required this.tokenType,
    required this.id,
    required this.firstName,
    required this.email,
    required this.username,
  });

  // Factory to create from JSON
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      id: json['id'],
      firstName: json['firstName'],
      email: json['email'],
      username: json['username'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'tokenType': tokenType,
      'id': id,
      'firstName': firstName,
      'email': email,
      'username': username,
    };
  }
}
