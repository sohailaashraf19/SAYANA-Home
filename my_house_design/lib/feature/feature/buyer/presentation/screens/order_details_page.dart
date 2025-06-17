import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({Key? key, required this.orderData}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String errorMessage = '';
  int? buyerId;

  @override
  void initState() {
    super.initState();
    getBuyerId();
    fetchOrderDetails();
  }

  Future<void> getBuyerId() async {
    final cachedBuyerId = await CacheHelper.getData(key: 'buyerId');
    if (cachedBuyerId != null) {
      print('📦 Loaded buyerId from cache: $cachedBuyerId');
      setState(() {
        buyerId = cachedBuyerId;
      });
    } else {
      print('⚠️ buyerId not found in cache');
    }
  }

  Future<void> fetchOrderDetails() async {
    final orderId = widget.orderData['order_id'];
    final url = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/getOrderDetails/$orderId');

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['order'] != null) {
        final orderItems = data['order']['order_items'] as List<dynamic>;

        setState(() {
          products = orderItems.map<Map<String, dynamic>>((item) {
            final product = item['product'];
            final imagePath = product['images'] != null &&
                    product['images'].isNotEmpty
                ? product['images'][0]['image_path']
                : null;

            final productId = product['product_id'];
            if (productId == null) {
              print('❌ product_id is null for product: $product');
            } else {
              print('✅ product_id = $productId for ${product['name']}');
            }

            return {
              'product_id': productId,
              'name': product['name'] ?? 'Unnamed Product',
              'image': imagePath != null
                  ? 'https://olivedrab-llama-457480.hostingersite.com/$imagePath'
                  : '',
            };
          }).toList();

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load order details.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

Future<void> reportProduct(int productId) async {
  if (buyerId == null) {
    print('❌ Cannot report: buyerId is null');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buyer ID not found. Please log in again.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final url = Uri.parse(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/report-product?product_id=$productId&buyer_id=$buyerId');
  try {
    final response = await http.post(url);
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      print('✅ Reported: ${data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Reported successfully!')),
      );
    } else if (response.statusCode == 403) {
      print('❌ Server error: 403 - Already reported');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You reported this product already.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      print('❌ Server error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.statusCode}')),
      );
    }
  } catch (e) {
    print('❌ Report request failed: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to report: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final orderId = widget.orderData['order_id'];
    final totalPrice = widget.orderData['total_price'];
   
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF003664), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: $orderId',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003664),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Total Price: \$${totalPrice.toString()}'),
                    
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final productId = product['product_id'];
                            final productName = product['name'];
                            final productImage = product['image'];

                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: productImage != null &&
                                        productImage.isNotEmpty
                                    ? Image.network(
                                        productImage,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, _) =>
                                            Icon(Icons.broken_image),
                                      )
                                    : Icon(Icons.image_not_supported),
                                title: Text(productName),
                                trailing: TextButton(
                                  onPressed: (productId != null)
                                      ? () => reportProduct(productId as int)
                                      : null,
                                  child: Text(
                                    'Report',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
