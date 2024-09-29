import 'package:flutter/cupertino.dart';
import 'Cart_Screen/Cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final List<CartItem> _orderItems = []; // New list to store orders

  List<CartItem> get cartItems => _cartItems;
  List<CartItem> get orderItems => _orderItems; // Getter for order items

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
        status: item.status,
      );
      notifyListeners();
    }
  }

  void checkout() {
    _orderItems.addAll(_cartItems); // Move all cart items to order list
    _cartItems.clear(); // Clear the cart after checkout
    notifyListeners();
  }
}
