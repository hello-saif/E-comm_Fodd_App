import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Favorite_Provider.dart';
import 'Food_Product_det.dart';

class FoodProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final String description;
  final String productId;
  final bool isFavorite;
  final String category; // Add the category field


  const FoodProductItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.productId,
    this.isFavorite = false,
    required this.category, // Add the category here

  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      favoritesProvider.isFavorite(productId) ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey<bool>(favoritesProvider.isFavorite(productId)),
                      color: favoritesProvider.isFavorite(productId) ? Colors.red : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(productId);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${price.toStringAsFixed(0)}৳",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        imageUrl: imageUrl,
                        name: name,
                        price: price,
                        rating: rating,
                        description: description,
                        productId: productId,
                        category: category, // Pass the category here

                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
