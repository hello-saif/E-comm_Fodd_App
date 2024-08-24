import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Screen/Categories/Categorystyle.dart';
import 'Screen/Oder_Section/Order.dart';
import 'Screen/Products_Items/Food_Product_Item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0; // To track the selected tab

  void _onBottomNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maan Food"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
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
                    return const CircularProgressIndicator(); // Loading indicator
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error message
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No images found'); // No data found message
                  }

                  var sliderImages = snapshot.data!.docs.map((doc) {
                    return {
                      'imageUrl': doc['imageUrl'],
                      'discount': doc['discount'] ?? 'No discount', // Default text if no discount is available
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
                                // Discount text
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    color: Colors.black.withOpacity(0.7),
                                    child: Text(
                                      'FOOD ${data['discount']} OFF', // Add "OFF" to the discount text
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
                      // Implement CategoriesScreen navigation
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
                    return const CircularProgressIndicator(); // Loading indicator
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error message
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No categories found'); // No data found message
                  }

                  var categories = snapshot.data!.docs;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding between categories
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
                      // Implement navigation to full product list
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
                    return const CircularProgressIndicator(); // Loading indicator
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Error message
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No products found'); // No data found message
                  }

                  var foodProducts = snapshot.data!.docs;
                  List<Widget> productRows = [];
                  for (int i = 0; i < foodProducts.length; i += 2) {
                    var product1 = foodProducts[i];
                    var product2 = i + 1 < foodProducts.length ? foodProducts[i + 1] : null;

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
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: productRows,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavBarTapped,
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


