import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_house_design/presentation/widgets/color.dart';


class OrderInfoPage extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderInfoPage({super.key, required this.order});

  @override
  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  String selectedStatus = 'pending';
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order['status']?.toString() ?? 'pending';
  }

  bool get isShipped => selectedStatus.toLowerCase() == 'shipped';

  Future<void> markAsShipped() async {
    if (isShipped) return;

    setState(() => isUpdating = true);

    final orderId = widget.order['id'].toString();
    final prefs = await SharedPreferences.getInstance();
    final sellerId = prefs.getString('seller_id') ?? '';

    final url = Uri.parse(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/orderupdate-status',
    );

    try {
      final res = await http.put(
        url,
        body: {
          'order_id': orderId,
          'seller_id': sellerId,
          'status': 'shipped',
        },
        headers: {'Accept': 'application/json'},
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order marked as shipped ✅')),
        );
        setState(() => selectedStatus = 'shipped');
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed ❌: ${res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error 🚫: $e')),
      );
    }

    setState(() => isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final buyerName = order['buyer']['name'];
    final totalPrice = order['total_price'];
    final orderItems = order['order_items'];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: boxColor,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Buyer: $buyerName',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Total: $totalPrice EGP',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.payment, color: Colors.deepOrange),
                        const SizedBox(width: 8),
                        Text('Status: $selectedStatus',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Order Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ...orderItems.map<Widget>((item) {
              final product = item['product'];
              final productName = product['name'];
              final quantity = item['quantity'];
              final price = item['price'];

              String? imagePath;
              if (product['images'] != null && product['images'].isNotEmpty) {
                imagePath = product['images'][0]['image_path'];
              }
              String? fullImageUrl;
              if (imagePath != null) {
                fullImageUrl = 'https://olivedrab-llama-457480.hostingersite.com/$imagePath';
              }

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: fullImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            fullImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 40),
                          ),
                        )
                      : const Icon(Icons.image_not_supported, size: 40),
                  title: Text('$productName (x$quantity)',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text('$price EGP',
                      style: const TextStyle(color: Colors.grey)),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: (isUpdating || isShipped) ? null : markAsShipped,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.local_shipping),
                label: isUpdating
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isShipped ? 'Already Shipped' : 'Mark as Shipped',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
