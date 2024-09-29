import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Products_Items/Food_Product_Item.dart';

class CategoryProducts extends StatelessWidget {
  final String categoryName;

  const CategoryProducts({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products in $categoryName'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foodProducts')
            .where('category', isEqualTo: categoryName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found in this category'));
          }

          var products = snapshot.data!.docs;
          List<Widget> productRows = [];

          for (int i = 0; i < products.length; i += 2) {
            var product1 = products[i].data() as Map<String, dynamic>;
            var product2 = i + 1 < products.length ? products[i + 1].data() as Map<String, dynamic> : null;

            productRows.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FoodProductItem(
                      imageUrl: product1['imageUrl'] ?? '',
                      name: product1['name'] ?? 'No Name',
                      price: (product1['price'] as num).toDouble(),
                      rating: (product1['rating'] as num).toDouble(),
                      description: product1['description'] ?? '',
                      productId: product1['productId'] ?? '',
                      isFavorite: product1['isFavorite'] ?? false,
                      category: product1['category'] ?? 'Unknown',
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  if (product2 != null)
                    Expanded(
                      child: FoodProductItem(
                        imageUrl: product2['imageUrl'] ?? '',
                        name: product2['name'] ?? 'No Name',
                        price: (product2['price'] as num).toDouble(),
                        rating: (product2['rating'] as num).toDouble(),
                        description: product2['description'] ?? '',
                        productId: product2['productId'] ?? '',
                        isFavorite: product2['isFavorite'] ?? false,
                        category: product2['category'] ?? 'Unknown',
                      ),
                    ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: productRows,
            ),
          );
        },
      ),
    );
  }
}
