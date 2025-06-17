import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/cart_page.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'pdPage.dart'; // Detail page

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<dynamic> products = [];
  bool loading = true;
  String errorMessage = '';
  int currentIndex = 1;
    Map<int, bool> favorites = {}; // Map to store favorite state for each product


  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

Future<void> fetchProducts() async {
  try {
    final cachedBuyerId = CacheHelper.getData(key: 'buyerId');
    print('🧍 Buyer ID from cache: $cachedBuyerId');

    if (cachedBuyerId == null || cachedBuyerId.toString().isEmpty) {
      setState(() {
        errorMessage = 'Buyer ID not found in cache.';
        loading = false;
      });
      return;
    }

    final url = Uri.parse(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/getwishlist?buyer_id=$cachedBuyerId',
    );
    print('🔗 Requesting: $url');

    final response = await http.get(url);
    print('🔍 Status Code: ${response.statusCode}');
    print('🧾 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        setState(() {
          products = List.from(data);
          favorites.clear();
          for (var item in products) {
            final product = item['product'];
            final productId = product['product_id'];
            if (productId != null) {
              favorites[int.parse(productId.toString())] = true;
            }
          }
          loading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected response format';
          loading = false;
        });
      }
    } else {
      setState(() {
        errorMessage =
            'Failed to load wishlist (Status: ${response.statusCode})';
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


  Future<void> removeFromWishlist(int productId) async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');

  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse(
    'https://olivedrab-llama-457480.hostingersite.com/public/api/removewishlist/$productId?buyer_id=$buyerId',
  );

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('✅ Removed from wishlist successfully');
      setState(() {
        products.removeWhere((item) => 
          item['product']['product_id'].toString() == productId.toString()
        );
      });
    } else {
      print('❌ Failed to remove from wishlist: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error removing from wishlist: $e');
  }
}
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
Future<void> addToCart(int productId) async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');

  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse(
    'https://olivedrab-llama-457480.hostingersite.com/public/api/cart_add?product_id=$productId&buyer_id=$buyerId',
  );

  try {
    final response = await http.post(url);

    if (response.statusCode == 200) {
      print('✅ Added to cart successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully')),
      );
    } else {
      print('❌ Failed to add to cart: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart')),
      );
    }
  } catch (e) {
    print('❌ Error adding to cart: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error adding to cart')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003664),
        title: const Text('Wishlist',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Text(
                    errorMessage.isEmpty ? "No products found" : errorMessage,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final wishlistItem = products[index];
                      final product = wishlistItem['product'];

                      final name = product['name']?.toString() ?? 'No Name';
                      final price = product['price']?.toString() ?? 'N/A';
                      final desc = product['description']?.toString() ?? '';
                      final productId = product['product_id'] != null
                          ? int.tryParse(product['product_id'].toString())
                          : null;

                      final List<dynamic>? imageList =
                          product['images'] as List<dynamic>?;
                      final String? imagePath = imageList != null &&
                              imageList.isNotEmpty &&
                              imageList[0]['image_path'] != null
                          ? imageList[0]['image_path']
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
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
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
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: imageUrl != null
                                          ? Image.network(
                                              imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                      Icons.broken_image,
                                                      size: 40),
                                            )
                                          : const Icon(
                                              Icons.image_not_supported,
                                              size: 40),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "\EGP$price",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.green),
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
                                      margin: const EdgeInsets.only(bottom: 4),
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
        favorites.remove(productId); // ✅ Completely remove from favorites map
      });
    } else {
      await addToWishlist(productId);
      setState(() {
        favorites[productId] = true; // ✅ Mark as favorite
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
    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87, size: 20),
    onPressed: () async {
      if (productId != null) {
        await addToCart(productId);
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

            Widget destination;
            switch (index) {
              case 0:
                destination = AllCategoriesPage();
                break;
              case 1:
                destination = const WishlistPage();
                break;
              case 2:
                destination = const HomeView();
                break;
              case 3:
                destination = const HomeScreen();
                break;
              case 4:
                destination = const SettingsPage();
                break;
              default:
                destination = const HomeView();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        items: [
          navitem(
              icon: Icons.grid_view,
              label: "Category",
              index: 0,
              currentIndex: currentIndex),
          navitem(
              icon: Icons.favorite,
              label: "Wishlist",
              index: 1,
              currentIndex: currentIndex),
          navitem(
              icon: Icons.home,
              label: "Home",
              index: 2,
              currentIndex: currentIndex),
                 navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),

          navitem(
              icon: Icons.settings,
              label: "Settings",
              index: 4,
              currentIndex: currentIndex),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
