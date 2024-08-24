import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String label;

  const CategoryItem({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}