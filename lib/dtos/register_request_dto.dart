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
