import 'package:flutter/cupertino.dart';
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';

class CartProvider extends ChangeNotifier {
  // stores the logged in user
  AuthResponseDto? _authResponseDto;

  AuthResponseDto? get getAuthResponseDto => _authResponseDto;

  void setAuthResponseDto(AuthResponseDto authResponseDto) {
    _authResponseDto = authResponseDto;
    notifyListeners();
  }

  void clearAuthResponseDto() {
    _authResponseDto = null;
    notifyListeners();
  }

  List<CartResponseDto> cart = [];

  List<CartResponseDto> get getCart => cart;

  void addProduct(CartResponseDto product) {
    cart.add(product);
    notifyListeners();
  }

  void removeProduct(CartResponseDto product) {
    cart.remove(product);
    notifyListeners();
  }

  // get log in status
  bool _isLoggedIn = false;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void setTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  bool get isLoggedIn => _isLoggedIn;
  void login() {
    _isLoggedIn = true;
    _currentIndex = 0;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentIndex = 0;
    notifyListeners();
  }
}
