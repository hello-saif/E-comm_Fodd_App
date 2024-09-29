import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../BottomNavBar.dart';
import '../Favorite_Provider.dart';
import '../Products_Items/Food_Product_Item.dart';

class Wishlist extends StatefulWidget {
  Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProductIds = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
                  (route) => false,
            ); // Go back to the BottomNavBar
          },
        ),
      ),
      body: favoriteProductIds.isEmpty
          ? const Center(
        child: Text(
          'No product selected.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('foodProducts').where('productId', whereIn: favoriteProductIds).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error message
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No favorite products found')); // No data found message
          }

          final products = snapshot.data!.docs;
          List<Widget> productRows = [];
          for (int i = 0; i < products.length; i += 2) {
            final product1 = products[i].data() as Map<String, dynamic>;
            final product2 = i + 1 < products.length ? products[i + 1].data() as Map<String, dynamic> : null;

            productRows.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FoodProductItem(
                      imageUrl: product1['imageUrl'] ?? '',
                      name: product1['name'] ?? 'No Name',
                      price: (product1['price'] as num).toDouble() ?? 0.0,
                      rating: (product1['rating'] as num).toDouble() ?? 0.0,
                      description: product1['description'] ?? '',
                      productId: product1['productId'] ?? '',
                      isFavorite: true,
                      category: product1['category'] ?? 'Unknown Category', // Added category
// This is optional as `isFavorite` is managed in the provider.
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  if (product2 != null)
                    Expanded(
                      child: FoodProductItem(
                        imageUrl: product2['imageUrl'] ?? '',
                        name: product2['name'] ?? 'No Name',
                        price: (product2['price'] as num).toDouble() ?? 0.0,
                        rating: (product2['rating'] as num).toDouble() ?? 0.0,
                        description: product2['description'] ?? '',
                        productId: product2['productId'] ?? '',
                        isFavorite: true,
                        category: product2['category'] ?? 'Unknown Category', // Added category
// This is optional as `isFavorite` is managed in the provider.
                      ),
                    ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: productRows,
            ),
          );
        },
      ),
    );
  }
}
