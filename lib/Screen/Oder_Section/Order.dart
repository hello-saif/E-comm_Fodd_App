import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Cart_Screen/Cart_model.dart';
import '../Provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String selectedStatus = 'All Orders'; // Track the selected tab

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<CartProvider>(context); // Get the cart provider

    // Filter orders based on the selected status
    List<CartItem> filteredOrders = orderProvider.orderItems.where((order) {
      if (selectedStatus == 'All Orders') return true; // Show all orders
      return order.status == selectedStatus; // Filter by status
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Column(
        children: [
          // Horizontal tab bar for order statuses
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab("All Orders"),
                  _buildTab("Pending"),
                  _buildTab("Processing"),
                  _buildTab("Delivered"),
                ],
              ),
            ),
          ),
          // List of Orders
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: filteredOrders.isNotEmpty
                  ? filteredOrders.map((order) {
                return _buildOrderItem(
                  imageUrl: order.imageUrl,
                  title: order.name,
                  price: 'Price: ${order.price}৳', // Display price as currency
                  status: order.status, // Use the actual status from order
                  statusColor: _getStatusColor(order.status),
                  quantity:'Quantity: ${order.quantity}', // Get color based on status
                );
              }).toList()
                  : [
                const Center(
                  child: Text(
                    'No orders yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build each tab
  Widget _buildTab(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = title; // Update the selected status
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: selectedStatus == title ? Colors.orange : Colors.grey, // Change color for active tab
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  // Method to get color based on order status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.yellow;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Sample _buildOrderItem method to display each order item
  Widget _buildOrderItem({
    required String imageUrl,
    required String title,
    required String price,
    required String status,
    required String quantity,
    required Color statusColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  Text(
                    quantity,
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Add padding for better appearance
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2), // Lighten the status color for background
                      borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 14, color: statusColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}