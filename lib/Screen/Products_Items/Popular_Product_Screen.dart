import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'Food_Product_Item.dart';

class PopularProductsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PopularProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Popular Products"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
                  (route) => false,
            ); // Go back to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('foodProducts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error message
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found')); // No data found message
          }

          var foodProducts = snapshot.data!.docs;
          List<Widget> productRows = [];
          for (int i = 0; i < foodProducts.length; i += 2) {
            var product1 = foodProducts[i].data() as Map<String, dynamic>;
            var product2 = i + 1 < foodProducts.length ? foodProducts[i + 1].data() as Map<String, dynamic> : null;

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
                      isFavorite: product1['isFavorite'] ?? false,
                      description: product1['description'] ?? '',
                      productId: product1['productId'] ?? '',
                      category: product1['category'] ?? 'Unknown Category', // Added category
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
                        isFavorite: product2['isFavorite'] ?? false,
                        description: product2['description'] ?? '',
                        productId: product2['productId'] ?? '',
                        category: product2['category'] ?? 'Unknown Category', // Added category
// Ensure this matches the field in Firestore
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
