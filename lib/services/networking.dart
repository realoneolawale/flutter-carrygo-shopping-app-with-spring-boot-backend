import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/dtos/register_request_dto.dart';

const String userUrl = 'http://localhost:8081/api/auth';

class NetworkHelper {
  late final String url;
  NetworkHelper(this.url);

  Future loginUser(String usernameOrEmail, String password) async {
    // add the headers
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // add the body
    final body = jsonEncode({
      'usernameOrEmail': usernameOrEmail,
      'password': password,
    });
    // add the url
    url = "$url/signin";
    // make the login request
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AuthResponseDto.fromJson(json);
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future registerUser(RegisterRequestDto registerDto) async {
    // add the body
    final body = {
      'firstName': registerDto.firstName,
      'lastName': registerDto.lastName,
      'username': registerDto.username,
      'phone': registerDto.phone,
      'email': registerDto.email,
      'password': registerDto.password,
    };
    // add the url
    url = "$url/signup";
    // make the login request
    try {
      http.Response response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 201) {
        String data = response.body;
        return data;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
