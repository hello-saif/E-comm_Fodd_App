import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Oder_Section/Order.dart';

class FoodProductItem extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final bool isFavorite;

  const FoodProductItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    this.isFavorite = false,
  });

  @override
  State<FoodProductItem> createState() => _FoodProductItemState();
}

class _FoodProductItemState extends State<FoodProductItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
       child:  Container(
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
                      widget.imageUrl,
                      height: 150.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: IconButton(
                      icon: Icon(
                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        // Handle favorite toggle
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.name,
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
                          "\$${widget.price.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16.0),
                            const SizedBox(width: 4.0),
                            Text(
                              widget.rating.toStringAsFixed(1),
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
                      // Navigate to the Order screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        )

    );
  }
}
