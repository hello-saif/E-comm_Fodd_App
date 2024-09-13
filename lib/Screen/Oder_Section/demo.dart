import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/BottomNavBar.dart';
import 'package:http/http.dart'as http;

import 'Order.dart';

class OrderScreen1 extends StatefulWidget {
  const OrderScreen1({super.key});

  @override
  _OrderScreen1State createState() => _OrderScreen1State();
}

class _OrderScreen1State extends State<OrderScreen1> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {},
        ),
        title: const Text('Test'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Ensure this is inside Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 26),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    hintText: "Enter Your Name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextFormField(
                  obscureText: true,
                  controller: _pass,
                  decoration: InputDecoration(
                    hintText: "Enter Your Pass",
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },

                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Login(_name.text.toString(), _pass.text.toString());
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> Login(String _name, _pass) async {
    try {
     final response = await http.post(Uri.parse('https://reqres.in/api/login'),
          headers: {
       'Content-type':'application/json'
          },
          body: {
            'email': _name,
            'password': _pass
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (kDebugMode) {
          print(data['token']);
        }

        if (kDebugMode) {
          print('login Success');
        }
      } else {
        if (kDebugMode) {
          print("login Failed");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

}


class updateProfile extends StatefulWidget {
  final String email;
  final String password;

  const updateProfile({
    super.key,
    required this.email,
    required this.password
  });

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OrderScreen()),
                  (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.email}'),
            const SizedBox(height: 10),
            Text('Password: ${widget.password}'),
          ],
        ),
      ),
    );
  }
}