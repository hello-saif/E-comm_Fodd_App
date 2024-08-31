import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/Screen/Wishlist/Wish_List.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color _selectedColor = Colors.orange.shade50; // Default color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body:
      Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp'), // Replace with your image URL
                ),
                SizedBox(height: 10),
                Text(
                  'Ibne Riead',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '+1586 4585 8745',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade100, // Set the background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),   // Rounded corner on the top-left
                  topRight: Radius.circular(40),  // Rounded corner on the top-right

                ),
              ),

              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.person_outline_sharp,

                    text: 'My Profile',
                    onTap: () {

                    },
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.payment,
                    text: 'Payment Setting',
                    onTap: () {

                    },
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    text: 'Notification',
                    onTap: () {

                    },
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.favorite_border,
                    text: 'Wishlist',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Wishlist()), (route) => false);

                    },
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.local_shipping_outlined,
                    text: 'Order Tracking',
                    onTap: () {

                    },
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Log Out',
                    onTap: () {

                    },
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  SizedBox(height: 16),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData? icon;
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor; // Background color
  final Widget? trailing;

  ProfileMenuItem({
    this.icon,
    required this.text,
    required this.onTap,
    this.backgroundColor = Colors.white, // Default background color
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Set the background color here
          borderRadius: BorderRadius.circular(40), // Rounded corners
        ),
        child: ListTile(
          leading: icon != null ? Icon(icon, color: Colors.orangeAccent) : null,
          title: Text(text),
          trailing: trailing != null ? trailing : null,
        ),
      ),
    );
  }
}
