import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/Screen/Wishlist/Wish_List.dart';
import '../../BottomNavBar.dart';
import '../SignIn_State/SiginUP_Screen.dart';
import 'MyProfile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color _selectedColor = Colors.orange.shade50; // Default color

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp'),
                ),
                const SizedBox(height: 10),
                Text(
                 'No Name',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'No Email',
                  style: const TextStyle(
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), // Rounded corner on the top-left
                  topRight: Radius.circular(40), // Rounded corner on the top-right
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.person_outline_sharp,
                    text: 'My Profile',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyProfile()),
                              (route) => false);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.payment,
                    text: 'Payment Setting',
                    onTap: () {},
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    text: 'Notification',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                              (route) => false);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.favorite_border,
                    text: 'Wishlist',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Wishlist()),
                              (route) => false);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.local_shipping_outlined,
                    text: 'Order Tracking',
                    onTap: () {},
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  const SizedBox(height: 16),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Log Out',
                    onTap: () {
                      _signOut(context);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    backgroundColor: _selectedColor, // Change color on tap
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
              (route) => false); // Navigate to the login screen after sign-out
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
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
