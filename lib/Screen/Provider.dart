import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth for current user
import 'Cart_Screen/Cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];
  final List<CartItem> _orderItems = []; // অর্ডার আইটেম রাখার জন্য নতুন লিস্ট

  List<CartItem> get cartItems => _cartItems;
  List<CartItem> get orderItems => _orderItems; // অর্ডার আইটেমের জন্য গেটার

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserId;

  // Constructor or method to get current user ID
  CartProvider() {
    _currentUserId = _auth.currentUser?.uid; // Get current user ID
  }

  String? get currentUserId => _currentUserId;
  // কার্টে আইটেম যোগ করা
  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  // কার্ট থেকে আইটেম মুছে ফেলা
  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // আইটেমের পরিমাণ আপডেট করা
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

  // Firebase-এ অর্ডার প্লেস করা এবং কার্ট খালি করা
  Future<void> placeOrder() async {
    try {
      // Get the current user's ID
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid; // Get current user ID

      if (currentUserId == null) {
        print('No user is currently signed in.');
        return; // Exit if no user is signed in
      }

      // Firebase এ অর্ডার সংরক্ষণ
      for (var order in _cartItems) {
        await FirebaseFirestore.instance.collection('orders').add({
          'userId': currentUserId, // Add current user's ID to the order
          'name': order.name,
          'imageUrl': order.imageUrl,
          'price': order.price,
          'quantity': order.quantity,
          'status': 'Pending', // ডিফল্ট স্ট্যাটাস 'Pending'
        });
      }

      // অর্ডারগুলো orderItems-এ স্থানান্তর করা এবং কার্ট খালি করা
      _orderItems.addAll(_cartItems); // অর্ডার লিস্টে কার্ট আইটেমগুলো যোগ করা
      _cartItems.clear(); // অর্ডার প্লেস করার পর কার্ট খালি করা
      notifyListeners();
    } catch (e) {
      print('Error placing order: $e');
    }
  }
}
