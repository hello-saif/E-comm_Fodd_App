import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String quantity;

  // Constructor to receive order details
  OrderDetailScreen({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity, required String status, required String time,
  });

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0; // Initialize the current step

  // Define the steps for the order status
  List<Step> steps = [
    Step(
      title: Text('Order'),
      content: Text('Order placed successfully.'),
      isActive: true,
    ),
    Step(
      title: Text('Pending'),
      content: Text(''),
      isActive: false,
    ),
    Step(
      title: Text('Confirmed'),
      content: Text('Your order has been confirmed.'),
      isActive: false,
    ),
    Step(
      title: Text('Processing'),
      content: Text('Your order is being processed.'),
      isActive: false,
    ),
    Step(
      title: Text('Delivered'),
      content: Text('Your order has been delivered.'),
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline for order status using Stepper
            Stepper(
              currentStep: currentStep,
              steps: steps,
              type: StepperType.vertical,
              onStepTapped: (step) {
                setState(() {
                  currentStep = step; // Update the current step when tapped
                });
              },
              onStepContinue: () {
                setState(() {
                  if (currentStep < steps.length - 1) {
                    currentStep += 1; // Move to the next step
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currentStep > 0) {
                    currentStep -= 1; // Move to the previous step
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            // Product details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.network(
                      widget.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.price,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                          Text(
                            'Quantity: ${widget.quantity}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your "Order Again" functionality here
                  },
                  child: const Text('Order Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your "Review" functionality here
                  },
                  child: const Text('Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
