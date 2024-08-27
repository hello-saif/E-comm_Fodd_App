import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offer"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('offers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var offerDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: offerDocs.length,
              itemBuilder: (context, index) {
                var offer = offerDocs[index];
                return OfferCard(
                  backgroundColor: Colors.orange.shade50, // Default color, or fetch from Firebase
                  imageUrl: offer['imageUrl'],
                  discount: offer['discount'],
                  buttonText: offer['buttonText'],
                  buttonColor: Colors.blueGrey, // Default color, or fetch from Firebase
                  textColor: Colors.orange, // Default color, or fetch from Firebase
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Color backgroundColor;
  final String imageUrl;
  final String discount;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  OfferCard({
    required this.backgroundColor,
    required this.imageUrl,
    required this.discount,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Food Package Offer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$discount Discount",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 120,  // Increase the size here
                height: 120, // Increase the size here
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
