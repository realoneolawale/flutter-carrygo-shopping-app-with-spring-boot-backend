class RegisterRequestDto {
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String email;
  final String password;

  RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
  });

  // Factory to create from JSON
  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) {
    return RegisterRequestDto(
        firstName: json['firstName'],
        lastName: json['lastName'],
          username: json['username'],
          phone: json['phone'],
          email: json['email'],
          password: json['password']
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }
}