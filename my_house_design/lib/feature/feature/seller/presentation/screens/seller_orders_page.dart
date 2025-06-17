import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/Settingss_Page.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/order_info_page.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/products_screen.dart';
import 'package:my_house_design/presentation/views/seller_home_page.dart';

class SellerOrdersPage extends StatefulWidget {
  const SellerOrdersPage({super.key});

  @override
  State<SellerOrdersPage> createState() => _SellerOrdersPageState();
}

class _SellerOrdersPageState extends State<SellerOrdersPage> {
  List<dynamic> orders = [];
  bool loading = true;
  String errorMessage = '';
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedSellerId = prefs.getString('seller_id');

      if (cachedSellerId == null || cachedSellerId.isEmpty) {
        setState(() {
          errorMessage = 'Seller ID not found in cache.';
          loading = false;
        });
        return;
      }

      final url = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/getOrdersForSeller?seller_id=$cachedSellerId',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            orders = data;
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
          errorMessage = 'Failed to load orders (Status: ${response.statusCode})';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SellerHomePage()),
          ),
        ),
        title: const Text('Orders', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(
                  child: Text(
                    errorMessage.isEmpty ? 'No orders found' : errorMessage,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final buyerName = order['buyer']['name'];
                      final totalPrice = order['total_price'];
                      final paymentStatus = order['payment_status'];
                      final orderItems = order['order_items'];
                      final status = order['status'];

                      String? imagePath;
                      if (orderItems != null &&
                          orderItems.isNotEmpty &&
                          orderItems[0]['product'] != null &&
                          orderItems[0]['product']['images'] != null &&
                          orderItems[0]['product']['images'].isNotEmpty) {
                        imagePath = orderItems[0]['product']['images'][0]['image_path'];
                      }

                      return GestureDetector(
                        onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => OrderInfoPage(order: order)),
  );
  fetchOrders(); // ✅ يعيد تحميل الطلبات تلقائياً
},
                        child: OrderCard(
                          buyerName: buyerName,
                          totalPrice: totalPrice,
                          paymentStatus: paymentStatus,
                          orderItems: orderItems,
                          imagePath: imagePath,
                          status: status,
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          setState(() => currentIndex = index);
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => destination));
        },
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          navitem(icon: Icons.inventory_2_outlined, label: 'Products', index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.shopping_cart_outlined, label: 'Orders', index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: 'Home', index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: 'Settings', index: 3, currentIndex: currentIndex),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String buyerName;
  final String totalPrice;
  final String paymentStatus;
  final List<dynamic> orderItems;
  final String? imagePath;
  final String status;

  const OrderCard({
    super.key,
    required this.buyerName,
    required this.totalPrice,
    required this.paymentStatus,
    required this.orderItems,
    required this.imagePath,
    required this.status,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shipped':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? fullImageUrl = imagePath != null
        ? 'https://olivedrab-llama-457480.hostingersite.com/$imagePath'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fullImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                fullImageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
              ),
            ),
          const SizedBox(height: 8),
          Text('Buyer: $buyerName', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Total Price: $totalPrice EGP', style: const TextStyle(color: Colors.black54)),
          Text('Payment Status: $paymentStatus', style: const TextStyle(color: Colors.black54)),
          Text('Order Status: $status',
              style: TextStyle(fontWeight: FontWeight.bold, color: _statusColor(status))),
          const SizedBox(height: 12),
          const Text('Order Items:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...orderItems.map((item) {
            final product = item['product'];
            final productName = product['name'];
            final quantity = item['quantity'];
            final price = item['price'];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text('$productName (x$quantity)', style: const TextStyle(fontWeight: FontWeight.w500))),
                  Text('$price EGP', style: const TextStyle(color: Colors.black54)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
