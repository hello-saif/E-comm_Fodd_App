import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteProducts = {};

  // Getter for the favorites list
  Set<String> get favorites => _favoriteProducts;

  bool isFavorite(String productId) {
    return _favoriteProducts.contains(productId);
  }

  void toggleFavorite(String productId) {
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
    notifyListeners();
  }
}
