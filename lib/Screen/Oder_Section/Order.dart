import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Provider.dart';
import 'OrderDetails_Screen.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String selectedStatus = 'All Orders'; // Track the selected tab

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<CartProvider>(context); // Get the cart provider
    final currentUserId = orderProvider.currentUserId; // Get the current user ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Column(
        children: [
          // Horizontal tab bar for order statuses
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab("All Orders"),
                  _buildTab("Pending"),
                  _buildTab("Confirmed"),
                  _buildTab("Processing"),
                  _buildTab("Delivered"),
                ],
              ),
            ),
          ),
          // List of Orders (real-time updates from Firestore)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: currentUserId) // Filter by current user ID
                  .snapshots(), // Real-time listener for 'orders' collection
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loader while waiting
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie animation for empty orders
                        Lottie.asset('animations/Animation_order.json', width: 250, height: 250),
                        const SizedBox(height: 20),
                        const Text('No orders yet.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                // Get orders from Firestore and filter based on selectedStatus
                List<QueryDocumentSnapshot> orders = snapshot.data!.docs;

                List<QueryDocumentSnapshot> filteredOrders = orders.where((order) {
                  Map<String, dynamic>? data = order.data() as Map<String, dynamic>?;

                  // Safely check if the 'status' key exists in the data
                  if (data != null && data.containsKey('status')) {
                    String status = data['status']; // Fetch status from Firebase data
                    if (selectedStatus == 'All Orders') return true;
                    return status == selectedStatus;
                  }
                  return false; // If no 'status' key, exclude the order
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    final data = order.data() as Map<String, dynamic>;

                    // Calculate total price based on price and quantity
                    double price = data['price'] ?? 0.0; // Ensure price is fetched correctly
                    int quantity = data['quantity'] ?? 0; // Ensure quantity is fetched correctly
                    double totalPrice = price * quantity; // Calculate total price

                    // Get the order time and format it; fallback to 'Unknown' if missing
                    Timestamp? orderTime = data['time']; // Get the order time
                    String formattedTime;
                    if (orderTime != null) {
                      formattedTime = _formatTimestamp(orderTime); // Format the time if available
                    } else {
                      formattedTime = 'Unknown Time'; // Default message if no time is available
                    }

                    return _buildOrderItem(
                      imageUrl: data['imageUrl'] ?? '', // Provide a default empty string if 'imageUrl' is missing
                      title: data['name'] ?? 'Unknown', // Default name
                      price: 'Price: ${totalPrice.toStringAsFixed(0)}৳', // Updated total price display
                      status: data['status'] ?? 'Unknown', // Default to 'Unknown' if 'status' is missing
                      statusColor: _getStatusColor(data['status'] ?? 'Unknown'),
                      quantity: 'Quantity: ${quantity}', // Default quantity to 0
                      time: formattedTime, // Pass formatted time to the item
                    );
                  },
                );
              },
            ),
          )
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
          borderRadius: BorderRadius.circular(28.0),
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
      case 'Confirmed':
        return Colors.lightGreen;
      case 'Processing':
        return Colors.indigoAccent;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Method to format timestamp to a readable string
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Convert to DateTime
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}"; // Format the date and time
  }

  // Method to build each order item
  Widget _buildOrderItem({
    required String imageUrl,
    required String title,
    required String price,
    required String status,
    required String quantity,
    required Color statusColor,
    required String time, // Added time parameter
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to OrderDetailScreen with order details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
              imageUrl: imageUrl,
              title: title,
              price: price,
              status: status,
              quantity: quantity,
              time: time, // Pass time to the OrderDetailScreen
            ),
          ),
        );
      },
      child: Card(
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
                    Text(
                      time, // Display order time here
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
      ),
    );
  }
}
