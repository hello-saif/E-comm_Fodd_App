import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth import
import 'package:foodiapp/BottomNavBar.dart'; // Your home screen
import 'package:foodiapp/Screen/SignIn_State/SiginUP_Screen.dart'; // Sign-in screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _backgroundImageUrl = '';
  String _logoUrl = '';
  String _version = '';

  @override
  void initState() {
    super.initState();
    _fetchSplashScreenData();
    // No need to call _moveToNextScreen(), since navigation is now handled by StreamBuilder
  }

  Future<void> _fetchSplashScreenData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('splashScreenData')
          .doc('splashData')
          .get();
      if (doc.exists) {
        setState(() {
          _backgroundImageUrl = doc['backgroundImageUrl'] ?? '';
          _logoUrl = doc['logoUrl'] ?? '';
          _version = doc['version'] ?? 'Unknown';
        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching splash screen data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (_backgroundImageUrl.isNotEmpty)
            Image.network(
              _backgroundImageUrl,
              fit: BoxFit.cover,
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ), // Placeholder if image URL is not available

          // Centered Logo and Version Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if (_logoUrl.isNotEmpty)
                  ClipOval(
                    child: Image.network(
                      _logoUrl,
                      width: 150, // Adjust width as needed
                      height: 150, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                const Spacer(),
                Text(
                  'Version $_version',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),

          // StreamBuilder to handle auth state changes
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  // User is logged in, navigate to the home screen
                  Future.microtask(() => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const BottomNavBar())));
                } else {
                  // User is not logged in, navigate to the sign-in screen
                  Future.microtask(() => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const SignIn())));
                }
              }
              return const SizedBox(); // Placeholder while checking the auth state
            },
          ),
        ],
      ),
    );
  }
}
