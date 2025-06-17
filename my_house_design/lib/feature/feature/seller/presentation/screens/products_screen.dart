import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/feature/feature/seller/presentation/screens/Settingss_Page.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/ProductScreenupdated.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/presentation/views/seller_home_page.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_orders_page.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> products = [];
  bool loading = true;
  String errorMessage = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedSellerId = prefs.getString('seller_id');
      print('📦 Fetched seller_id from cache: $cachedSellerId');

      if (cachedSellerId == null || cachedSellerId.isEmpty) {
        setState(() {
          errorMessage = 'Seller ID not found in cache.';
          loading = false;
        });
        return;
      }

      final url = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/get_product_by_seller_id?seller_id=$cachedSellerId',
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
              'Failed to load products (Status: ${response.statusCode})';
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

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/delete_products/$productId',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
        fetchProducts();  // Refresh the product list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SellerHomePage()),
            );
          },
        ),
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.black),
            ),
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
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final name = product['name']?.toString() ?? 'No Name';
                      final price = product['price']?.toString() ?? 'N/A';
                      final imageList = product['images'] as List<dynamic>?;

                      final String? imagePath = imageList != null &&
                              imageList.isNotEmpty &&
                              imageList[0]['image_path'] != null
                          ? imageList[0]['image_path']
                          : null;

                      final imageUrl = (imagePath != null && imagePath.isNotEmpty)
                          ? 'https://olivedrab-llama-457480.hostingersite.com/$imagePath'
                          : 'assets/images/default_image.jpg';

                      return ProductCard(
                        name: name,
                        price: price,
                        imagePath: imageUrl,
                        productId: product['product_id'].toString(),
                        onDelete: () {
                          deleteProduct(product['product_id'].toString());
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductScreen(
                                productId: product['product_id'].toString(),
                                name: name,
                                description: product['description']?.toString() ?? '',
                                price: price,
                                quantity: product['quantity']?.toString() ?? '0',
                                categoryId: product['category_id']?.toString() ?? '0',
                              ),
                            ),
                          );
                        },
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
                destination = const ProductScreen();
                break;
              case 1:
                destination = const SellerOrdersPage();
                break;
              case 2:
                destination = const SellerHomePage();
                break;
              case 3:
                destination = const SettingssPage();
                break;
              default:
                destination = const SellerHomePage();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        items: [
          navitem(icon: Icons.inventory_2_outlined, label: "Products", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.shopping_cart_outlined, label: "Orders", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 3, currentIndex: currentIndex),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imagePath;
  final String productId;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.productId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          imagePath.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imagePath,
                    width: 60, // Set the width for the image
                    height: 60, // Set the height for the image
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.image_not_supported, size: 60),

          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                  maxLines: 1, // Allow text to be truncated after one line
                ),
                Text(
                  '$price EGP',
                  style: const TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                  maxLines: 1, // Allow text to be truncated after one line
                ),
              ],
            ),
          ),

          // Action buttons
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF003664)),
            onPressed: onDelete,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF003664)),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
