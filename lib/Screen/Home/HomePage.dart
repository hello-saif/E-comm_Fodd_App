import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Categories/Categories_Screen.dart';
import '../Categories/CategoryProductsScreen.dart';
import '../Categories/Categorystyle.dart';
import '../Products_Items/Food_Product_Item.dart';
import '../Products_Items/Popular_Product_Screen.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maan Food"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement navigation to notifications screen if needed
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
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 4),
                  Text('Error Location'), // Placeholder for location
                ],
              ),
              const SizedBox(height: 16),

              // Search Field
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase(); // Update the search text
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0), // Adjust padding here
                ),
              ),
              const SizedBox(height: 24),

              // Carousel Slider
              StreamBuilder(
                stream: widget._firestore.collection('sliderImages').snapshots(),
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
                        MaterialPageRoute(builder: (context) => AllCategory()),
                      );
                    },
                    child: const Text("See all", style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Fetching category data from Firestore with search filter applied
              StreamBuilder(
                stream: widget._firestore.collection('categories').snapshots(),
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

                  // Filter categories based on search query
                  var filteredCategories = categories.where((doc) {
                    var categoryName = doc['name']?.toString().toLowerCase() ?? '';
                    return categoryName.contains(searchText);
                  }).toList();

                  if (filteredCategories.isEmpty) {
                    return const Center(child: Text('No categories match your search'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filteredCategories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to a new screen when category is tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryProducts(categoryName: category['name']),
                                ),
                              );
                            },
                            child: CategoryItem(
                              imageUrl: category['imageUrl'],
                              label: category['name'],
                            ),
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
                  const Text("Popular Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

              // Food Products List fetched from Firebase with search filter applied
              StreamBuilder(
                stream: widget._firestore.collection('foodProducts').snapshots(),
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

                  // Filter products based on search query
                  var filteredProducts = foodProducts.where((doc) {
                    var productName = doc['name']?.toString().toLowerCase() ?? '';
                    return productName.contains(searchText);
                  }).toList();

                  // If no search, limit to 4 products
                  if (searchText.isEmpty) {
                    filteredProducts = filteredProducts.take(4).toList();
                  }

                  if (filteredProducts.isEmpty) {
                    return const Center(child: Text('No products match your search'));
                  }

                  List<Widget> productRows = [];
                  for (int i = 0; i < filteredProducts.length; i += 2) {
                    var product1 = filteredProducts[i].data() as Map<String, dynamic>;
                    var product2 = i + 1 < filteredProducts.length
                        ? filteredProducts[i + 1].data() as Map<String, dynamic>
                        : null;

                    productRows.add(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FoodProductItem(
                              imageUrl: product1['imageUrl'] ?? '',
                              name: product1['name'] ?? 'No Name',
                              price: (product1['price'] as num).toDouble() ?? 0.0,
                              rating: (product1['rating'] as num).toDouble() ?? 0.0,
                              isFavorite: product1['isFavorite'] ?? false,
                              description: product1['description'] ?? '',
                              productId: product1['productId'] ?? '',
                              category: product1['category'] ?? 'Unknown Category', // Added category
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (product2 != null)
                            Expanded(
                              child: FoodProductItem(
                                imageUrl: product2['imageUrl'] ?? '',
                                name: product2['name'] ?? 'No Name',
                                price: (product2['price'] as num).toDouble() ?? 0.0,
                                rating: (product2['rating'] as num).toDouble() ?? 0.0,
                                isFavorite: product2['isFavorite'] ?? false,
                                description: product2['description'] ?? '',
                                productId: product2['productId'] ?? '',
                                category: product1['category'] ?? 'Unknown Category', // Added category
                              ),
                            )
                          else
                            const Spacer(),
                        ],
                      ),
                    );
                  }

                  return Column(children: productRows);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
