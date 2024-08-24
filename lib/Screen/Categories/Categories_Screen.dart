import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Categorystyle.dart';

class CategoriesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('categories').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // লোডিং ইন্ডিকেটর
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // ত্রুটি বার্তা
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No categories found')); // ডেটা না পাওয়া গেলে বার্তা
          }

          var categories = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return CategoryItem(
                imageUrl: category['imageUrl'],
                label: category['name'],
              );
            },
          );
        },
      ),
    );
  }
}
