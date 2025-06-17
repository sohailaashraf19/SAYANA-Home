import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';
import 'pdPage.dart'; // Import your detail page

class CategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<dynamic> products = [];
  bool loading = true;
  String errorMessage = '';
  int currentIndex = 0; // Set the default index for the BottomNavigationBar to Home (index 2)
  Map<int, bool> favorites = {}; // Map to store favorite state for each product
    Map<int, bool> cartItems = {};


Future<void> fetchCart() async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');
  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getcart?buyer_id=$buyerId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        setState(() {
          for (var item in data) {
            final productId = item['product_id'];
            if (productId != null) {
              cartItems[int.parse(productId.toString())] = true;
            }
          }
        });
      }
    } else {
      print('❌ Failed to fetch cart: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching cart: $e');
  }
}

@override
void initState() {
  super.initState();
  fetchProducts();
  fetchWishlist(); // Add this!
  fetchCart();  // <-- Just call it normally here
}

Future<void> fetchWishlist() async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');

  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getwishlist?buyer_id=$buyerId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Assuming the data is a list of wishlist items
      if (data is List) {
        setState(() {
          for (var item in data) {
            final productId = item['product_id'];
            if (productId != null) {
              favorites[int.parse(productId.toString())] = true;
            }
          }
        });
      }
    } else {
      print('❌ Failed to fetch wishlist: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching wishlist: $e');
  }
}
  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse(
          'https://olivedrab-llama-457480.hostingersite.com/public/api/products_category/${widget.categoryId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          products = List<dynamic>.from(data);
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.categoryName,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003664),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AllCategoriesPage()),
            );
          },
        ),
        ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Text(
                    errorMessage.isEmpty ? "No products found" : errorMessage,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      final name = product['name']?.toString() ?? 'No Name';
                      final price = product['price']?.toString() ?? 'N/A';
                      final desc = product['description']?.toString() ?? '';
                      final productId = product['product_id'] != null ? int.tryParse(product['product_id'].toString()) : null;

                      final imagePath = product['images'] != null &&
                          product['images'].isNotEmpty &&
                          product['images'][0]['image_path'] != null
                          ? product['images'][0]['image_path']
                          : null;

                      final imageUrl = imagePath != null
                          ? 'https://olivedrab-llama-457480.hostingersite.com/$imagePath'
                          : null;
Future<void> addToWishlist(int productId) async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');

  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/addwishlist?buyer_id=$buyerId&product_id=$productId');

  try {
    final response = await http.post(url);

    if (response.statusCode == 200) {
      print('✅ Added to wishlist successfully');
    } else {
      print('❌ Failed to add to wishlist: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error adding to wishlist: $e');
  }
}
Future<void> removeFromWishlist(int productId) async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');

  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/removewishlist/$productId?buyer_id=$buyerId');

  try {
    final response = await http.delete(url); // Use POST as you said

    if (response.statusCode == 200) {
      print('✅ Removed from wishlist successfully');
    } else {
      print('❌ Failed to remove from wishlist: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error removing from wishlist: $e');
  }
}

// ignore: unused_element
Future<void> fetchCart() async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');
  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getcart?buyer_id=$buyerId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        setState(() {
          for (var item in data) {
            final productId = item['product_id'];
            if (productId != null) {
              cartItems[int.parse(productId.toString())] = true;
            }
          }
        });
      }
    } else {
      print('❌ Failed to fetch cart: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching cart: $e');
  }
}

  Future<void> addToCart(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/cart_add?product_id=$productId&buyer_id=$buyerId');

    try {
      await http.post(url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error adding to cart')));
    }
  }

  Future<void> removeFromCart(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/cartdelet/$productId?buyer_id=$buyerId');

    try {
      await http.delete(url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error removing from cart')));
    }
  }



                      // Check if the product is already marked as favorite

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                imageUrl: imageUrl ?? '',
                                title: name,
                                price: price,
                                description: desc,
                                productId: productId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: imageUrl != null
                                          ? Image.network(
                                              imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image, size: 40),
                                            )
                                          : const Icon(Icons.image_not_supported, size: 40),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "\EGP$price",
                                      style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 20, 85, 197) , fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8), // Space between icons
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
 icon: Icon(
  favorites[productId] == true ? Icons.favorite : Icons.favorite_border,
  color: favorites[productId] == true ? Colors.red : Colors.black87,
  size: 20,
),

onPressed: () async {
  if (productId != null) {
    if (favorites[productId] == true) {
      await removeFromWishlist(productId);
      setState(() {
        favorites[productId] = false; // Unmark as favorite
      });
    } else {
      await addToWishlist(productId);
      setState(() {
        favorites[productId] = true; // Mark as favorite
      });
    }
  }
},



  
  
)

                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                     child: IconButton(
                                        icon: Icon(
                                          cartItems[productId] == true
                                              ? Icons.shopping_cart
                                              : Icons.shopping_cart_outlined,
                                          color: cartItems[productId] == true ? Colors.green : Colors.black87,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          if (productId != null) {
                                            if (cartItems[productId] == true) {
                                              await removeFromCart(productId);
                                              setState(() {
                                                cartItems[productId] = false;
                                              });
                                            } else {
                                              await addToCart(productId);
                                              setState(() {
                                                cartItems[productId] = true;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            setState(() {
              currentIndex = index;
            });

            // Navigate to the corresponding page
            Widget destination;
            switch (index) {
              case 0:
                destination = AllCategoriesPage();
                break;
              case 1:
                destination = WishlistPage();
                break;
              case 2:
                destination = HomeView();
                break;
              case 3:
                destination = HomeScreen();
                break;
              case 4:
                destination = SettingsPage();
                break;
              default:
                destination = HomeView();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        items: [
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite_border, label: "My Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
