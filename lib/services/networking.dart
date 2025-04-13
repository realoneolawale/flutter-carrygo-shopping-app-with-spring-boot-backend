import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/dtos/register_request_dto.dart';

const String userUrl = 'http://10.0.2.2:8081/api/auth'; // android emulator
//const String userUrl = 'http://localhost:8081/api/auth'; // ios emulator

class NetworkHelper {
  late final String url;

  Future<dynamic> loginUser(String usernameOrEmail, String password) async {
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
    url = "$userUrl/signin";
    // make the login request
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        // get json string
        //final json = jsonDecode(response.body);
        // convert JSON string to Map
        Map<String, dynamic> authResponseMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        // create DTO from Map
        AuthResponseDto responseDto = AuthResponseDto.fromJson(authResponseMap);
        return responseDto;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future registerUser(RegisterRequestDto registerDto) async {
    final headers = {'Content-Type': 'application/json'};
    // add the url
    url = "$userUrl/signup";
    // make the login request
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(registerDto.toJson()), headers: headers);
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
