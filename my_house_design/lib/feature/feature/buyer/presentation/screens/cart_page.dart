import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/billing_address_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  bool loading = true;
  String errorMessage = '';
  int currentIndex = 3;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final buyerId = CacheHelper.getData(key: 'buyerId');
      if (buyerId == null || buyerId.toString().isEmpty) {
        setState(() {
          errorMessage = 'Buyer ID not found in cache.';
          loading = false;
        });
        return;
      }

      final url = Uri.parse(
          'https://olivedrab-llama-457480.hostingersite.com/public/api/getcart?buyer_id=$buyerId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            cartItems = data;
            loading = false;
            calculateTotalPrice();
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected response format';
            loading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load cart';
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

  void calculateTotalPrice() {
    double price = 0.0;
    for (var item in cartItems) {
      final product = item['product'];
      final productPrice = double.tryParse(product['price'].toString()) ?? 0.0;
      final quantity = item['quantity'] ?? 1;
      price += productPrice * quantity;
    }
    setState(() {
      totalPrice = price;
    });
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final buyerId = CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/updatecart?buyer_id=$buyerId&product_id=$productId&quantity=$quantity');

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) fetchCart();
    } catch (e) {
      print('Update Error: $e');
    }
  }

  Future<void> removeFromCart(int productId) async {
    final buyerId = CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/cartdelet/$productId?buyer_id=$buyerId');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          cartItems.removeWhere((item) =>
              item['product']['product_id'].toString() == productId.toString());
          calculateTotalPrice();
        });
      }
    } catch (e) {
      print('Delete Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003664),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          },
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          'assets/images/WhatsApp Image 2025-06-15 at 2.56.59 PM.jpeg',
                          height: 300,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003664),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: const Text('Continue Shopping' ,
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (_, index) {
                          final item = cartItems[index];
                          final product = item['product'];
                          final name = product['name'] ?? '';
                          final price = double.tryParse(product['price'].toString()) ?? 0.0;
                          final imageUrl =
                              'https://olivedrab-llama-457480.hostingersite.com/${product['images'][0]['image_path']}';
                          final quantity = item['quantity'] ?? 1;
                          final productId = product['product_id'];

                          return Card(
                            color: boxColor,
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.network(imageUrl,
                                      width: screenWidth * 0.2,
                                      height: screenWidth * 0.2,
                                      fit: BoxFit.cover),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text("\EGP${price.toStringAsFixed(2)}"),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                if (quantity > 1) {
                                                  updateQuantity(productId, quantity - 1);
                                                }
                                              },
                                            ),
                                            Text(quantity.toString()),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                updateQuantity(productId, quantity + 1);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                removeFromCart(productId);
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total: EGP${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BillingAddressPage()),
                              );
                            },
                            child: const Text("Proceed to Checkout"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;

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
              destination = const CartPage();
              break;
            case 4:
              destination = const SettingsPage();
              break;
            default:
              destination = const HomeView();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite, label: "Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.shopping_cart, label: "My Cart", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
      ),
    );
  }
}
