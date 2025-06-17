import 'package:admin_sayana/Screens/Category_Manage/admin_category.dart';
import 'package:admin_sayana/Screens/Find_User/admin_find_users_page.dart';
import 'package:admin_sayana/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ProductImage {
  final int id;
  final int productId;
  final String imagePath;

  ProductImage({
    required this.id,
    required this.productId,
    required this.imagePath,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      imagePath: json['image_path'],
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(int) onItemSelected;

  const HomePage({super.key, required this.onItemSelected});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> buyers = [];
  List<int> buyerIds = [];
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> sellers = [];
  List<Map<String, dynamic>> searchResults = [];
  int productCount = 0;
  int sellerCount = 0;
  int customerCount = 0;
  String totalSales = "0 LE";
  String revenue = "0 LE";
  bool isLoading = true;
  bool isSalesAndRevenueLoading = true;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    fetchBuyers();
    fetchProducts();
    fetchSellers();
    fetchSalesAndRevenue();
    fetchCustomerCount();

    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      fetchProducts();
      fetchSellers();
      fetchCustomerCount();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  Future<void> fetchBuyers() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/buyerstop'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          buyers = data.cast<Map<String, dynamic>>();
          buyerIds = buyers.map((buyer) => buyer['buyer_id'] as int).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load buyers. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching buyers: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/adminproducts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          products = data.cast<Map<String, dynamic>>();
          productCount = products.length;
        });
      } else {
        throw Exception('Failed to load products. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchSellers() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/sellerscount'),
      );

      print('Sellers Count API Response Status: ${response.statusCode}');
      print('Sellers Count API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sellerCount = data['total_sellers'] ?? 0;
        });
      } else {
        throw Exception('Failed to load seller count. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching seller count: $e');
      setState(() {
        sellerCount = 0;
      });
    }
  }

  Future<void> fetchSalesAndRevenue() async {
    try {
      setState(() {
        isSalesAndRevenueLoading = true;
      });
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/revenueforadmin'),
      );

      print('Sales and Revenue API Response Status: ${response.statusCode}');
      print('Sales and Revenue API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          totalSales = "${(double.tryParse(data['total_sales']?.toString() ?? '0') ?? 0).toStringAsFixed(2)} EGP";
          revenue = "${(double.tryParse(data['revenus']?.toString() ?? '0') ?? 0).toStringAsFixed(2)} EGP";
          isSalesAndRevenueLoading = false;
        });
      } else {
        throw Exception('Failed to load sales and revenue. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sales and revenue: $e');
      setState(() {
        totalSales = "0 EGP";
        revenue = "0 EGP";
        isSalesAndRevenueLoading = false;
      });
    }
  }

  Future<void> fetchCustomerCount() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/buyerscount'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          customerCount = data['total_buyer'] ?? 0;
        });
      } else {
        throw Exception('Failed to load customer count. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching customer count: $e');
      setState(() {
        customerCount = 0;
      });
    }
  }

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      setState(() {
        searchResults.clear();
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/search?query=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          searchResults = data.cast<Map<String, dynamic>>().map((item) {
            return {
              ...item,
              'images': (item['images'] as List?)
                      ?.map((image) => ProductImage.fromJson(image))
                      .toList() ??
                  [],
            };
          }).toList();
          // Print the search results to debug image_url
          for (var item in searchResults) {
            print('Search Result: ${item['name']} - images: ${item['images']?.map((img) => img.imagePath).toList()}');
          }
        });
        _showOverlay();
      } else {
        throw Exception('Failed to search. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching: $e');
    }
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          // Close the overlay when tapping outside
          _removeOverlay();
        },
        child: Stack(
          children: [
            // Transparent background to capture taps
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              width: size.width - 40,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 60),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: searchResults.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No results found"),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final item = searchResults[index];
                              final images = item['images'] as List<ProductImage>? ?? [];
                              return ListTile(
                                leading: images.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          'https://olivedrab-llama-457480.hostingersite.com/${images[0].imagePath}',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/img/placeholder.png', // تأكدي إن الصورة موجودة في المشروع
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.image_not_supported, size: 50),
                                title: Text(item['name'] ?? 'Unknown'),
                                onTap: () {
                                  _searchController.text = item['name'] ?? '';
                                  _removeOverlay();
                                },
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hello Sohaila !',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person_search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminFindUserPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.grid_view),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCategory()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => fetchSearchResults(value),
                  decoration: InputDecoration(
                    hintText: 'Search product',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: boxColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📦 Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildStatBox(productCount.toString(), "Products")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildStatBox(sellerCount.toString(), "Sellers")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          isSalesAndRevenueLoading ? "0" : revenue,
                          "Revenue",
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: _buildStatBox(customerCount.toString(), "Customers")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildStatBox(
                    isSalesAndRevenueLoading ? "0" : totalSales,
                    "Total Sales",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 👥 Best Users
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Best Users",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : buyers.isEmpty
                              ? const Center(child: Text("No results found"))
                              : ListView.builder(
                                  itemCount: buyers.length,
                                  itemBuilder: (context, index) {
                                    final item = buyers[index];
                                    return _buildUserRow(
                                      index + 1,
                                      item['name'] ?? 'Unknown',
                                      'Customer',
                                      index: index,
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
      ),
    );
  }

  static Widget _buildStatBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  static Widget _buildUserRow(int no, String name, String type, {required int index}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? boxColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(no.toString()),
          Text(name),
          Text(type),
        ],
      ),
    );
  }
}