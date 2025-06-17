// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/custom_scroll_Items.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/pdPage.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/app_bare_home.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/sarch_bar_home.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic> allProducts = [];
  bool loading = true;
  String errorMessage = '';
  final ScrollController _scrollController = ScrollController();

  List<String> imageUrlList = [
    "assets/images/image-1740173095228.jpg",
    "assets/images/Amazon-PaisaWapas-Deal-copy-3.webp",
    "assets/images/image-1738880758878.jpg",
  ];

  final PageController _pageController = PageController();
  Timer? _timer;
  int currentIndex = 2;
  Map<int, bool> favorites = {};
    Map<int, bool> cartItems = {};


  @override
  void initState() {
    super.initState();
    fetchOffersData();
    fetchWishlist();
      fetchCart();  // <-- Just call it normally here

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= imageUrlList.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }
 
  Future<void> removeFromWishlist(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/removewishlist/$productId?buyer_id=$buyerId');

    try {
      await http.delete(url);
    } catch (e) {
      print('❌ Error removing from wishlist: $e');
    }
  }

  // Cart
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
        setState(() {
          favorites[productId] = true;
        });
      } else {
        print('❌ Failed to add to wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error adding to wishlist: $e');
    }
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

  Future<void> fetchOffersData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://olivedrab-llama-457480.hostingersite.com/public/api/products/best-selling'));
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allProducts = data.take(100).toList();
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
  void dispose() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent / 2);
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF003664);
    const selectedIconColor = Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          const AppBarHome(),
          const SearchBarHome(),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : allProducts.isEmpty
                    ? Center(
                        child: Text(
                          errorMessage.isEmpty
                              ? "No products available"
                              : errorMessage,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 180,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: imageUrlList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        imageUrlList[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 100,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomScrollItems(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Add the "Best Selling Item" text here
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Best Selling Item",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: allProducts.length,
                                itemBuilder: (context, index) {
                                  final offer = allProducts[index];
                                  final productName = offer['name']?.toString() ?? 'No Name';
                                  final productPrice = offer['price']?.toString() ?? 'N/A';
                                  final description = offer['description']?.toString() ?? '';
                                  final productId = offer['product_id'] != null
                                      ? int.tryParse(offer['product_id'].toString())
                                      : null;

                                  final imagePath = offer['images'] != null &&
                                          offer['images'].isNotEmpty &&
                                          offer['images'][0]['image_path'] != null
                                      ? offer['images'][0]['image_path']
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
                                            title: productName,
                                            price: productPrice,
                                            description: description,
                                            productId: productId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: const Color.fromARGB(255, 255, 255, 255),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
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
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              const Icon(Icons.broken_image, size: 40),
                                                        )
                                                      : const Icon(Icons.image_not_supported, size: 40),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  productName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  "\EGP$productPrice",
                                                  style: const TextStyle(
                                                      fontSize: 14, fontWeight: FontWeight.bold , color: Color.fromARGB(255, 20, 85, 197)),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    favorites[productId] == true
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: favorites[productId] == true
                                                        ? Colors.red
                                                        : Colors.black87,
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
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
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
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
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
                destination = const AllCategoriesPage();
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
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite_border, label: "Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
        selectedItemColor: selectedIconColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}