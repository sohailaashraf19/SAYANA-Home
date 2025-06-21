import 'package:admin_sayana/Screens/Category_Manage/admin_category.dart';
import 'package:admin_sayana/Screens/Find_User/admin_find_users_page.dart';
import 'package:admin_sayana/Screens/Product/admin_product_page.dart';
import 'package:admin_sayana/Screens/Reports/admin_report_page.dart';
import 'package:admin_sayana/Screens/Voucher/admin_voucher_page.dart';
import 'package:admin_sayana/Screens/Order/admin_order_page.dart';
import 'package:admin_sayana/Screens/Login/login_page.dart';
import 'package:admin_sayana/Screens/Feedback/admin_Feedback.dart'; // تأكد من وجود المسار الصحيح لصفحة الفيدباك
import 'package:admin_sayana/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:admin_sayana/globals.dart' as globals;

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

  int selectedDrawerIndex = 0;

  // Admin profile data
  String? adminName;
  String? adminEmail;

  // --- Trending Products ---
  List<Map<String, dynamic>> trendingProducts = [];

  @override
  void initState() {
    super.initState();
    fetchAdminProfile();
    fetchBuyers();
    fetchProducts();
    fetchSellers();
    fetchSalesAndRevenue();
    fetchCustomerCount();
    fetchTrendingProducts();

    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      fetchProducts();
      fetchSellers();
      fetchCustomerCount();
      fetchTrendingProducts();
    });
  }

  Future<void> fetchAdminProfile() async {
    try {
      final token = globals.globalToken ?? '';
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/admin/adminprofile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          adminName = data['name']?.toString() ?? 'Admin';
          adminEmail = data['email']?.toString() ?? '';
        });
      } else {
        if (!mounted) return;
        setState(() {
          adminName = 'Admin';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        adminName = 'Admin';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void onDrawerItemSelected(int index) {
    setState(() {
      selectedDrawerIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pop(context); // Home (stay here)
        break;
      case 1:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminFindUserPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminCategory()));
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProductPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
        break;
      case 5:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReportsPage()));
        break;
      case 6:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VouchersPage()));
        break;
      default:
        Navigator.pop(context);
    }
  }

  void onFeedbackPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeedbackPage()),
    );
  }

  // ----------- Logout Function -----------
  Future<void> logout() async {
    try {
      final token = globals.globalToken ?? '';
      final response = await http.post(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/admin/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        globals.globalToken = null;
        globals.globalAdminId = null;
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
  // ---------------------------------------

  Future<void> fetchBuyers() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/buyerstop'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          buyers = data.cast<Map<String, dynamic>>();
          buyerIds = buyers.map((buyer) => buyer['buyer_id'] as int).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load buyers. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/adminproducts'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          products = data.cast<Map<String, dynamic>>();
          productCount = products.length;
        });
      } else {
        throw Exception('Failed to load products. Status: ${response.statusCode}');
      }
    } catch (e) {}
  }

  Future<void> fetchSellers() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/sellerscount'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          sellerCount = data['total_sellers'] ?? 0;
        });
      } else {
        throw Exception('Failed to load seller count. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        sellerCount = 0;
      });
    }
  }

  Future<void> fetchSalesAndRevenue() async {
    try {
      if (!mounted) return;
      setState(() {
        isSalesAndRevenueLoading = true;
      });
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/revenueforadmin'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          totalSales = "${(double.tryParse(data['total_sales']?.toString() ?? '0') ?? 0).toStringAsFixed(2)} EGP";
          revenue = "${(double.tryParse(data['revenus']?.toString() ?? '0') ?? 0).toStringAsFixed(2)} EGP";
          isSalesAndRevenueLoading = false;
        });
      } else {
        throw Exception('Failed to load sales and revenue. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
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
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          customerCount = data['total_buyer'] ?? 0;
        });
      } else {
        throw Exception('Failed to load customer count. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        customerCount = 0;
      });
    }
  }

  Future<void> fetchTrendingProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getadminPopularProducts'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> data;
        if (decoded is Map && decoded.containsKey('products')) {
          data = decoded['products'];
        } else if (decoded is List) {
          data = decoded;
        } else {
          data = [];
        }
        setState(() {
          trendingProducts = data.cast<Map<String, dynamic>>();
        });
      } else {
        setState(() {
          trendingProducts = [];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        trendingProducts = [];
      });
    }
  }

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) {
      _removeOverlay();
      if (!mounted) return;
      setState(() {
        searchResults.clear();
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/search?query=$query'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (!mounted) return;
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
        });
        _showOverlay();
      } else {
        throw Exception('Failed to search. Status: ${response.statusCode}');
      }
    } catch (e) {}
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _removeOverlay();
        },
        child: Stack(
          children: [
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
                                              'assets/img/placeholder.png',
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
      drawer: Drawer(
        child: Container(
          color: primaryColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 28,
                      backgroundImage: AssetImage('assets/SYANA HOME.png'),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adminName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerTile(Icons.home, 'Home', 0),
              _buildDrawerTile(Icons.person_search, 'Find Users', 1),
              _buildDrawerTile(Icons.grid_view, 'Categories', 2),
              _buildDrawerTile(Icons.shopping_bag, 'Products', 3),
              _buildDrawerTile(Icons.receipt_long, 'Orders', 4),
              _buildDrawerTile(Icons.bar_chart, 'Reports', 5),
              _buildDrawerTile(Icons.card_giftcard, 'Vouchers', 6),
              ListTile(
                leading: Icon(Icons.feedback, color: Colors.white),
                title: Text('Feedback', style: TextStyle(color: Colors.white)),
                onTap: onFeedbackPressed,
              ),
              const Divider(color: Colors.white70),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: Icon(Icons.menu, color: primaryColor),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 22,
                            backgroundImage: AssetImage('assets/SYANA HOME.png'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            adminName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Search Field
                CompositedTransformTarget(
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
                const SizedBox(height: 20),
                // Stats
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
                // Total Sales Centered
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: _buildStatBox(
                        isSalesAndRevenueLoading ? "0" : totalSales,
                        "Total Sales",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Best Users Section
                const Text(
                  "Best Users",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buyers.isEmpty
                        ? const Center(child: Text("No results found"))
                        : ListView.builder(
                            itemCount: buyers.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
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
                const SizedBox(height: 20),
                // Trending Product Section (directly after Best Users)
                const Text(
                  "Trending Product",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                trendingProducts.isEmpty
                    ? const Text("No trending products found.")
                    : SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingProducts.length,
                          separatorBuilder: (context, idx) => const SizedBox(width: 12),
                          itemBuilder: (context, idx) {
                            final product = trendingProducts[idx];
                            final String imageUrl =
                                product['image'] != null && product['image'].toString().isNotEmpty
                                    ? 'https://olivedrab-llama-457480.hostingersite.com/${product['image']}'
                                    : 'https://via.placeholder.com/80';
                            return Container(
                              width: 180,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primaryColor, width: 1),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        'assets/img/placeholder.png',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      product['name'] ?? '',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, int index) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () => onDrawerItemSelected(index),
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