//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class PopularDealItem extends StatelessWidget {
//   final String imagePath;
//   final String name;
//   final double rating;
//   final double price;
//   final double? oldPrice;
//
//   PopularDealItem({
//     required this.imagePath,
//     required this.name,
//     required this.rating,
//     required this.price,
//     this.oldPrice,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 2 - 24,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.asset(imagePath), // Add your image here
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.orange, size: 16),
//                     Text("$rating"),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text("\$$price", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     if (oldPrice != null) ...[
//                       SizedBox(width: 8),
//                       Text(
//                         "\$$oldPrice",
//                         style: TextStyle(decoration: TextDecoration.lineThrough),
//                       ),
//                     ]
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     PopularDealItem(
//       imagePath: 'assets/pizza.png',
//       name: "Delicious Pizza",
//       rating: 4.5,
//       price: 8.5,
//     ),
//     PopularDealItem(
//       imagePath: 'assets/burger.png',
//       name: "Burger Wanted",
//       rating: 5.0,
//       price: 8.5,
//       oldPrice: 10.9,
//     ),
//   ],
// ),