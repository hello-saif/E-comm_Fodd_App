import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Categories/Categories_Screen.dart';
import '../Categories/Categorystyle.dart';
import '../Products_Items/Food_Product_Item.dart';
import '../Products_Items/Popular_Product_Screen.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maan Food"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>CartPage()), (route) => false);
            },
          ),
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location and Search
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 4),
                  Text("Dhaka, Bangladesh"),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 24),

              // Carousel Slider
              StreamBuilder(
                stream: _firestore.collection('sliderImages').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No images found'));
                  }

                  var sliderImages = snapshot.data!.docs.map((doc) {
                    return {
                      'imageUrl': doc['imageUrl'],
                      'discount': doc['discount'] ?? 'No discount',
                    };
                  }).toList();

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 170,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: sliderImages.map((data) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(data['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    color: Colors.black.withOpacity(0.7),
                                    child: Text(
                                      'FOOD ${data['discount']} OFF',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoriesScreen()),
                      );
                    },
                    child: const Text("See all", style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Fetching category data from Firestore
              StreamBuilder(
                stream: _firestore.collection('categories').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  }

                  var categories = snapshot.data!.docs;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CategoryItem(
                            imageUrl: category['imageUrl'],
                            label: category['name'],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Popular Product Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Popular Product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularProductsScreen()),
                      );
                    },
                    child: const Text("See all", style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Food Products List fetched from Firebase
              StreamBuilder(
                stream: _firestore.collection('foodProducts').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  var foodProducts = snapshot.data!.docs;
                  var limitedProducts = foodProducts.take(4).toList(); // Limit to first 4 products

                  List<Widget> productRows = [];
                  for (int i = 0; i < limitedProducts.length; i += 2) {
                    var product1 = limitedProducts[i];
                    var product2 = i + 1 < limitedProducts.length ? limitedProducts[i + 1] : null;

                    productRows.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FoodProductItem(
                              imageUrl: product1['imageUrl'],
                              name: product1['name'],
                              price: product1['price'].toDouble(),
                              rating: product1['rating'].toDouble(),
                              isFavorite: product1['isFavorite'] ?? false,
                              description: product1['description'],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          if (product2 != null)
                            Expanded(
                              child: FoodProductItem(
                                imageUrl: product2['imageUrl'],
                                name: product2['name'],
                                price: product2['price'].toDouble(),
                                rating: product2['rating'].toDouble(),
                                isFavorite: product2['isFavorite'] ?? false,
                                description: product2['description'],

                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: productRows,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
