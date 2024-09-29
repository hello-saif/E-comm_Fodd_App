import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/Screen/Dark_Mode_Provider.dart';
import 'package:foodiapp/Screen/Wishlist/Wish_List.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../BottomNavBar.dart';
import '../SignIn_State/SiginUP_Screen.dart';
import 'MyProfile.dart';
import 'Profile.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  final Color _selectedColor = Colors.orange.shade50;

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final darkthememode = Provider.of<DarkThemeMode>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              darkthememode.Chnagetheme();
            },
            icon: Icon(Icons.dark_mode),
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            User user = snapshot.data!;
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                       user.displayName.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.uid ?? 'No Email',  // Provide a fallback if email is null
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // The rest of your profile screen remains unchanged
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
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
                          backgroundColor: _selectedColor,
                        ),
                        const SizedBox(height: 16),
                        ProfileMenuItem(
                          icon: Icons.payment,
                          text: 'Payment Setting',
                          onTap: () {},
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          backgroundColor: _selectedColor,
                        ),
                        const SizedBox(height: 16),
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          text: 'Notification',
                          onTap: () {

                          },
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          backgroundColor: _selectedColor,
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
                          backgroundColor: _selectedColor,
                        ),
                        const SizedBox(height: 16),
                        ProfileMenuItem(
                          icon: Icons.local_shipping_outlined,
                          text: 'Order Tracking',
                          onTap: () {},
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          backgroundColor: _selectedColor,
                        ),
                        const SizedBox(height: 16),
                        ProfileMenuItem(
                          icon: Icons.logout,
                          text: 'Log Out',
                          onTap: () {
                            _signOut(context);
                          },
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          backgroundColor: _selectedColor,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No user is signed in.'));
          }
        },
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false,
      );
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
