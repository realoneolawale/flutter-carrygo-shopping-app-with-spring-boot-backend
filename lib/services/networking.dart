import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';
import 'package:shopping_app/dtos/product_response_dto.dart';
import 'package:shopping_app/dtos/register_request_dto.dart';

// my IP: 192.168.0.175
const String baseUrl = 'http://10.0.2.2:40160/'; // android emulator
//const String baseUrl = 'http://127.0.0.1:40160/'; // iOS simulator
const String userUrl = '${baseUrl}api/auth';
const String productUrl = '${baseUrl}api/products';
const String shoppingUrl = '${baseUrl}api/shopping';

class NetworkHelper {
  late final String url;
  // For Development purposes only
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
      //http.Response response = await client.post(Uri.parse(url), headers: headers, body: body);
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
      //http.Response response = await client.post(Uri.parse(url), body: jsonEncode(registerDto.toJson()), headers: headers);
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

  Future<List<CartResponseDto>> getUserCartItems(int userId) async {
    // add the url
    url = "$shoppingUrl/$userId";
    // make the login request
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // get json string and convert JSON string to List Map
        List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        // create DTO from Map
        List<CartResponseDto> responseDTOs =
            jsonList.map((json) => CartResponseDto.fromJson(json)).toList();
        return responseDTOs;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ProductResponseDto>> getProducts(int? categoryId) async {
    // add the headers
    //final headers = {'Content-Type': 'application/json'};
    // add the url
    if (categoryId != null) {
      url = "$productUrl/category/$categoryId";
    } else {
      url = productUrl;
    }
    // make the login request
    try {
      final response = await http.get(Uri.parse(url));
      //final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // get json string and convert JSON string to List Map
        List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
        // create DTO from Map
        List<ProductResponseDto> responseDTOs =
            jsonList.map((json) => ProductResponseDto.fromJson(json)).toList();
        return responseDTOs;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
