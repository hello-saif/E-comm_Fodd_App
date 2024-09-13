import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
              final ratingrate=user['rating']['rate'];
              final ratingcount=user['rating']['count'];

              return Container(

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8.0,
                        offset: const Offset(0, 4),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.network(
                              '${user['image']}',
                              height: 350.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Title:${user['title']}',maxLines: 1,),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('Price:${user['price']}'),
                          SizedBox(
                            width: 7,
                          ),
                          Text('Category:${user['category']}'),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(Icons.star,color: Colors.amber,),
                          Text('$ratingrate/$ratingcount'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Description: ${user['description']}',maxLines: 2,)
                    ],
                  ),
                ),
              );
            }));
  }

  List<dynamic> users = [];
  Future<void> _list() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      users = data;
      print(users);
    } else {
      print('your data list fail');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _list();
    super.initState();
  }
}
