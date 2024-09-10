import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:http/http.dart' as http;

class OrderScreen3 extends StatefulWidget {
  const OrderScreen3({super.key});

  @override
  _OrderScreen3State createState() => _OrderScreen3State();
}

class _OrderScreen3State extends State<OrderScreen3> {
  List<dynamic> users = [];
  Future<void> _list() async {
    final response =
    await http.get(Uri.parse("https://reqres.in/api/unknown"));
    if (response.statusCode == 200) {
      final data=jsonDecode(response.body);
      users=data['data'];
      setState(() {
        if (kDebugMode) {
          print(users);
        }
      });
    } else {
      if (kDebugMode) {
        print('data Failed');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('User Info'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        ),
        body: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user=users[index];
              return ListTile(
                leading: CircleAvatar(
                  //backgroundColor: Color(user['color']),
                  backgroundImage: NetworkImage(user['color']),
                ),
                title: Text('${user['name']} ${user['year']}'),
                subtitle: Text('${user['pantone_value']}'),
              );
            }));
  }
}
