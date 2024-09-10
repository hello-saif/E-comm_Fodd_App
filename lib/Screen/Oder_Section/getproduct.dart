import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderScreen4 extends StatefulWidget {
  const OrderScreen4({super.key});

  @override
  _OrderScreen4State createState() => _OrderScreen4State();
}

class _OrderScreen4State extends State<OrderScreen4> {
  List<dynamic> users = [];
  @override
  void initState() {
    // TODO: implement initState
    product();
    super.initState();
  }

  Future<void> product() async {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/category/jewelery'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      users = data;
      if (kDebugMode) {
        print(users);
      }
    } else {
      if (kDebugMode) {
        print('Load data error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {},
        ),
        title: const Text('Test'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            final rating = user['rating']['rate'];
            final ratingcount = user['rating']['count'];

            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['image']),
                  ),
                  title: Text(
                      'Title:${user['title']}\n Description: ${user['description']} \nRating: ${rating}  Reviews: ${ratingcount}'),
                  subtitle: Text(
                      'Price: \$${user['price']} \nCategory: ${user['category']}'),


                ),
              ],
            );
          }),
    );
  }
}
