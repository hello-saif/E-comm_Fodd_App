import 'package:flutter/cupertino.dart';

import 'Cart_Screen/Cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    final index = _cartItems.indexOf(item);
    if (index != -1) {
      _cartItems[index] = CartItem(
        imageUrl: item.imageUrl,
        name: item.name,
        price: item.price,
        quantity: quantity,
      );
      notifyListeners();
    }
  }
}
