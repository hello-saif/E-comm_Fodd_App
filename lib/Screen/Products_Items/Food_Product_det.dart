import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../Cart_Screen/Cart_model.dart';
import '../Provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  final String description; // Add description field

  const ProductDetailPage({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.description, // Pass description in constructor
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _counter = 1;
  bool _isFavorite = false;

  void addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(
      CartItem(
        imageUrl: widget.imageUrl,
        name: widget.name,
        price: widget.price,
        quantity: _counter,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product has been added to your cart.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(  // Wrap the entire body in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                  widget.imageUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_counter > 1) _counter--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '$_counter',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 90),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.price.toStringAsFixed(0)}৳',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(widget.rating.toStringAsFixed(1)),
                  ],
                ),
                const Spacer(),
                const Row(
                  children: [
                    Icon(Icons.timer, color: Colors.orange, size: 20),
                    Text('20-30 Min'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.description,  // Display product description from Firebase
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Read More...',
              style: TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addToCart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
