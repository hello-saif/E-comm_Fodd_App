import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodiapp/Screen/Dark_Mode_Provider.dart';
import 'package:provider/provider.dart';
import 'Screen/Favorite_Provider.dart';
import 'Screen/Loader/Loader.dart';
import 'Screen/Provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>DarkThemeMode()),
        ChangeNotifierProvider(
          create: (context) => FavoritesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
      ],
      child: const MaanFoodApp(), // Replace with your main app widget
    ),
  );
}


class MaanFoodApp extends StatelessWidget {
  const MaanFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkthememode=Provider.of<DarkThemeMode>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkthememode.Thememode ? ThemeData.dark():ThemeData.light(),

      home: const SplashScreen(),
    );
  }
}