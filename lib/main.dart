import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screen/Loader/Loader.dart';
import 'Screen/Provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
        child: const  MaanFoodApp(),
      ),
 );
}

class MaanFoodApp extends StatelessWidget {
  const MaanFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SplashScreen(),
    );
  }
}