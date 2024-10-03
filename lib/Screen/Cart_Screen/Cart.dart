import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:provider/provider.dart';

import '../Payment/Cart_Page.dart';
import '../Provider.dart'; // Import your provider

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cartItems.isEmpty
                ? const Center(
              child: Text('Your cart is empty'),
            )
                : ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        item.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Display price multiplied by quantity here
                            Text(
                              '${(item.price * item.quantity).toStringAsFixed(0)}৳', // Corrected here
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Quantity: ${item.quantity}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (item.quantity > 1) {
                                cartProvider.updateQuantity(item, item.quantity - 1);
                              }
                            },
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cartProvider.updateQuantity(item, item.quantity + 1);
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cartProvider.removeFromCart(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    // Recalculate total cost whenever the cart changes
                    double totalCost = cartProvider.cartItems.fold(
                      0.0,
                          (sum, item) => sum + (item.price * item.quantity),
                    );

                    return Text(
                      '${totalCost.toStringAsFixed(0)}৳',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Checkout function call
                  Provider.of<CartProvider>(context, listen: false).placeOrder();
                  // Navigate to CheckoutPage after successful checkout
                  // Uncomment the following code to navigate
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CheckoutPage(totalAmount: totalCost),
                  //   ),
                  //   (route) => false, // This option will remove previous screens
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Checkout'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
