
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_sayana/theme/color.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      print('Starting fetchOrders...');
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getAllorder'),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });
      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        List<dynamic> ordersData;

        if (responseData is List) {
          ordersData = responseData;
        } else if (responseData is Map<String, dynamic>) {
          ordersData = [responseData];
        } else {
          throw Exception('Unexpected response format');
        }

        ordersData = ordersData.where((order) {
          return order['order_items'] != null &&
              order['order_items'] is List &&
              order['buyer'] != null &&
              order['buyer']['name'] != null;
        }).toList();

        setState(() {
          orders = ordersData.map((order) => {
                'id': order['id'],
                'buyer_id': order['buyer_id'],
                'total_price': order['total_price'],
                'notes': order['notes'],
                'payment_status': order['payment_status'],
                'payment_method': order['payment_method'],
                'offer': order['offer'],
                'address_id': order['address_id'],
                'status': order['status'],
                'order_items': (order['order_items'] as List<dynamic>).map((item) => {
                      'id': item['id'],
                      'order_id': item['order_id'],
                      'product_id': item['product_id'],
                      'quantity': item['quantity'],
                      'price': item['price'],
                      'saller_id': item['saller_id'],
                      'status': item['status'],
                      'product': {
                        'product_id': item['product']['product_id'],
                        'name': item['product']['name'],
                        'description': item['product']['description'],
                        'price': item['product']['price'],
                        'quantity': item['product']['quantity'],
                        'category_id': item['product']['category_id'],
                        'sales_count': item['product']['sales_count'],
                        'saller_id': item['product']['saller_id'],
                        'color': item['product']['color'],
                        'type': item['product']['type'],
                        'discount': item['product']['discount'],
                        'reportcount': item['product']['reportcount'],
                        'images': (item['product']['images'] as List<dynamic>?)?.map((image) => {
                              'id': image['id'],
                              'product_id': image['product_id'],
                              'image_path': image['image_path'],
                            }).toList() ?? [],
                      },
                    }).toList(),
                'buyer': {
                  'buyer_id': order['buyer']['buyer_id'],
                  'name': order['buyer']['name'],
                },
              }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchOrders: $e');
      String errorText;
      if (e.toString().contains('Request timed out')) {
        errorText = 'Request timed out. Please check your internet connection.';
      } else if (e.toString().contains('Unexpected response format')) {
        errorText = 'Invalid data format received from the server.';
      } else {
        errorText = 'Error fetching orders: $e';
      }
      setState(() {
        isLoading = false;
        errorMessage = errorText;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // ← هنا تقدر تغير لون الخلفية
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/SYANA HOME.png'),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Orders",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
              SliverToBoxAdapter(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(child: Text(errorMessage!))
                        : OrdersListView(orders: orders),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersListView extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const OrdersListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? const Center(child: Text('No orders available'))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final firstItem = order['order_items'].isNotEmpty ? order['order_items'][0] : null;

              String imageUrl;
              if (firstItem != null &&
                  firstItem['product']['images'] != null &&
                  firstItem['product']['images'].isNotEmpty) {
                final rawPath = firstItem['product']['images'][0]['image_path'] ?? '';
                imageUrl = 'https://olivedrab-llama-457480.hostingersite.com/${rawPath.replaceFirst(RegExp(r'^/?public/'), '')}';
              } else {
                imageUrl = 'asset://assets/default.png';
              }

              final productName = firstItem != null ? firstItem['product']['name'] ?? 'N/A' : 'No Items';
              final quantity = firstItem != null ? firstItem['quantity'] ?? 0 : 0;
              final sellerId = firstItem != null ? firstItem['product']['saller_id'].toString() : 'N/A';

              return OrderContainer(
                image: imageUrl,
                name: productName,
                customerName: order['buyer']['name'] ?? 'N/A',
                sellerName: sellerId,
                Status: order['status'] ?? 'N/A',
                mount: quantity,
                price: double.tryParse(order['total_price'].toString()) ?? 0.0,
                statusColor: order['status'] == 'completed'
                    ? Colors.green
                    : order['status'] == 'canceled'
                        ? Colors.red
                        : Colors.orange,
              );
            },
          );
  }
}

class OrderContainer extends StatelessWidget {
  const OrderContainer({
    super.key,
    required this.image,
    required this.name,
    required this.customerName,
    required this.sellerName,
    required this.Status,
    required this.mount,
    required this.price,
    required this.statusColor,
  });

  final String image;
  final String name;
  final String customerName;
  final String sellerName;
  final String Status;
  final int mount;
  final double price;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: boxColor,
      ),
      child: Row(
        children: [
          OrderImage(image: image),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoRow("Name :", name),
              infoRow("Customer Name :", customerName),
              infoRow("Seller ID :", sellerName),
              infoRow("Amount :", mount.toString()),
              infoRow("Price :", "$price EGP"),
              infoRow("Status :", Status, statusColor: statusColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoRow(String title, String value, {Color? statusColor}) {
    return Row(
      children: [
        Text("$title ", style: const TextStyle(fontSize: 16,)),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: statusColor ?? Colors.black),
        ),
      ],
    );
  }
}

class OrderImage extends StatelessWidget {
  const OrderImage({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    final isNetwork = image.startsWith('http');
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: isNetwork
          ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset('assets/default.png', fit: BoxFit.cover),
            )
          : Image.asset(
              image.replaceFirst('asset://', ''),
              fit: BoxFit.cover,
            ),
    );
  }
}