import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodiapp/Screen/Offer_Screen/Offer.dart';
import 'package:foodiapp/Screen/Profile_Screen/Profile.dart';
import 'Screen/Cart_Screen/Cart.dart';
import 'Screen/Home/HomePage.dart';
import 'Screen/Oder_Section/Order.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    Home_Page(firestore: FirebaseFirestore.instance),
    OrderScreen(),
    CartPage(),
    const OfferScreen(),
    ProfileScreen(),
  ];

  void _onBottomNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
