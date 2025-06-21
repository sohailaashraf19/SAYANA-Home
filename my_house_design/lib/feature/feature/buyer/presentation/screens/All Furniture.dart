import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';

import 'pdPage.dart'; // Product detail page

class AllFurniture extends StatefulWidget {
  const AllFurniture({super.key});

  @override
  _AllFurnitureState createState() => _AllFurnitureState();
}

class _AllFurnitureState extends State<AllFurniture> {
  List<dynamic> products = [];
  bool loading = true;
  String errorMessage = '';
  int currentIndex = 0;
  Map<int, bool> favorites = {};
  Map<int, bool> cartItems = {}; // <-- Store cart items status dynamically

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchWishlist();
    fetchCart();  // Fetch cart items dynamically
  }
  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/get_all_products');
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



  // Fetch Wishlist
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

  // Fetch Cart
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
                cartItems[int.parse(productId.toString())] = true;  // Mark product as in cart
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

  // Add to Cart
  Future<void> addToCart(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/cart_add?product_id=$productId&buyer_id=$buyerId');
    try {
      await http.post(url);
      setState(() {
        cartItems[productId] = true;  // Mark as added to cart
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error adding to cart')));
    }
  }

  // Remove from Cart
  Future<void> removeFromCart(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/cartdelet/$productId?buyer_id=$buyerId');
    try {
      await http.delete(url);
      setState(() {
        cartItems[productId] = false;  // Mark as removed from cart
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error removing from cart')));
    }
  }

  // Add to Wishlist
  Future<void> addToWishlist(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/addwishlist?buyer_id=$buyerId&product_id=$productId');
    try {
      await http.post(url);
      setState(() {
        favorites[productId] = true; // Immediately update UI
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to wishlist')));
    } catch (e) {
      print('❌ Error adding to wishlist: $e');
    }
  }

  // Remove from Wishlist
  Future<void> removeFromWishlist(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/removewishlist/$productId?buyer_id=$buyerId');
    try {
      await http.delete(url);
      setState(() {
        favorites[productId] = false; // Immediately update UI
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from wishlist')));
    } catch (e) {
      print('❌ Error removing from wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await fetchWishlist(); // Refetch wishlist when navigating back
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(title: const Text('All Furniture', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF003664),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
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
                            ).then((_) => fetchWishlist()); // Refetch wishlist after returning
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
                                        style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 20, 85, 197),fontWeight: FontWeight.bold),
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
                                      // Wishlist Icon
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 8),
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
                                                  favorites[productId] = false;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Removed from wishlist')),
                                                );
                                              } else {
                                                await addToWishlist(productId);
                                                setState(() {
                                                  favorites[productId] = true;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Added to wishlist')),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      // Cart Icon
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            cartItems[productId] == true ? Icons.shopping_cart : Icons.add_shopping_cart,
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
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Removed from cart')),
                                                );
                                              } else {
                                                await addToCart(productId);
                                                setState(() {
                                                  cartItems[productId] = true;
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Added to cart')),
                                                );
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
            setState(() => currentIndex = index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) {
                  switch (index) {
                    case 0:
                      return const AllCategoriesPage();
                    case 1:
                      return WishlistPage();
                    case 2:
                      return HomeView();
                    case 3:
                      return HomeScreen();
                    case 4:
                      return SettingsPage();
                    default:
                      return HomeView();
                  }
                },
              ),
            );
          }
        },
        items: [
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite_border, label: "Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      ),
    );
  }
}
