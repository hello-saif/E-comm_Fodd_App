import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<dynamic> users1 = [];

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
        itemCount: users1.length,
        itemBuilder: (context, index) {
          final user = users1[index];

          // final ratingrate = user['rating']['rate'];
          // final ratingcount = user['rating']['count'];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(
                  '${user['image']}',
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user['firstName']} ${user['maidenName']} ${user['lastName']}',
                    maxLines: 1,
                    style: const TextStyle(color: Colors.pink),
                  ),
                  Text(
                    '${user['email']}',
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                  Row(

                    children: [
                      Text(
                        'Age:${user['age']}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Gender:${user['gender']}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      //birthDate
                      Text(
                        'Birth${user['birthDate']}',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),


                    ],
                  )
                ],
              ),
              subtitle: Text(
                '',
                maxLines: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _list() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/users'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Ensure 'data' contains a list of users. Update 'users' based on the API response structure.
      users1 = data['users'];
      if (kDebugMode) {
        print(users1);
      }
      setState(() {}); // Update UI after fetching data
    } else {
      if (kDebugMode) {
        print('Error List');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _list();
  }
}
