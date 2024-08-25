import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../BottomNavBar.dart';

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
        title: const Text("Order"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavBar()), (route) => false) ;// Go back to the previous screen
          },
        ),
      ),
      body: const Center(
        child: Text("Order Screen"),
      ),
    );
  }
}

