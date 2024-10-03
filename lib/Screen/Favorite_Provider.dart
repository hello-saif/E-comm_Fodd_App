import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider with ChangeNotifier {
  Set<String> _favoriteProducts = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for the favorites list
  Set<String> get favorites => _favoriteProducts;

  FavoritesProvider() {
    _loadFavoritesFromFirestore();  // This automatically loads on provider initialization
  }

  // New method to manually load favorites
  Future<void> loadFavorites() async {
    await _loadFavoritesFromFirestore();  // Call the private method to load data
  }

  // Private method to load favorites from Firestore
  Future<void> _loadFavoritesFromFirestore() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      List<dynamic> favoriteProductIds = userDoc['favorites'] ?? [];
      _favoriteProducts = favoriteProductIds.cast<String>().toSet();
      notifyListeners();
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.contains(productId);
  }

  // Updated toggleFavorite method with Firestore integration and debug print statements
  Future<void> toggleFavorite(String productId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    if (isFavorite(productId)) {
      _favoriteProducts.remove(productId);
      if (kDebugMode) {
        print('Removed from favorites: $productId');
      }
    } else {
      _favoriteProducts.add(productId);
      if (kDebugMode) {
        print('Added to favorites: $productId');
      }
    }

    // Save updated favorites to Firestore
    await _saveFavoritesToFirestore();
    notifyListeners();
  }

  Future<void> _saveFavoritesToFirestore() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).set({
        'favorites': _favoriteProducts.toList(),
      }, SetOptions(merge: true));
    }
  }
}
