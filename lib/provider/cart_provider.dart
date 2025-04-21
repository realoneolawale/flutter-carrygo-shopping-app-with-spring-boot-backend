import 'package:flutter/cupertino.dart';
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';

class CartProvider extends ChangeNotifier {
  final List<CartResponseDto> cart = [];
  // stores the logged in user
  AuthResponseDto? _authResponseDto;

  AuthResponseDto? get getAuthResponseDto => _authResponseDto;

  void setAuthResponseDto(AuthResponseDto authResponseDto) {
    _authResponseDto = authResponseDto;
    notifyListeners();
  }

  void addProduct(CartResponseDto product) {
    cart.add(product);
    notifyListeners();
  }

  void removeProduct(CartResponseDto product) {
    cart.remove(product);
    notifyListeners();
  }
}
