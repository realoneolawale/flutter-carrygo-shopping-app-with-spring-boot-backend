import 'package:flutter/cupertino.dart';
import 'package:shopping_app/dtos/auth_response_dto.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cart = [];
  // stores the logged in user
  late AuthResponseDto user = AuthResponseDto(
      accessToken: '',
      tokenType: '',
      id: 0,
      firstName: '',
      email: '',
      username: '');

  void addProduct(Map<String, dynamic> product) {
    cart.add(product);
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    cart.remove(product);
    notifyListeners();
  }
}
