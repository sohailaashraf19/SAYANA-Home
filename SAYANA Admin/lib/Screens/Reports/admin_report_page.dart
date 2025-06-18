import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_sayana/theme/color.dart';
import 'package:admin_sayana/Screens/Home/admin_home_page.dart'; // تأكد من المسار الصحيح

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Map<String, dynamic>> reportedProducts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchReportedProducts();
  }

  Future<void> fetchReportedProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/productsreported'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          reportedProducts = data.map<Map<String, dynamic>>((p) => {
                'name': p['product_name']?.toString() ?? 'Unknown',
                'seller': p['seller_name']?.toString() ?? 'Unknown Seller',
                'image_path': p['product_image']?.toString() ?? '',
                'reportCount': p['reportcount'] ?? 0,
                'seller_id': p['seller_id'] ?? 0,
              }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Status ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching reports: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28, color: primaryColor),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage(onItemSelected: (_) {})),
                (route) => false,
              );
            },
          ),
          title: const Text(
            "Reports",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : ReportsListView(products: reportedProducts),
        ),
      ),
    );
  }
}

// ------------------------ ReportsListView ------------------------

class ReportsListView extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ReportsListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];

        String imageUrl = '';
        final rawPath = product['image_path']?.toString() ?? '';
        if (rawPath.isNotEmpty) {
          imageUrl = 'https://olivedrab-llama-457480.hostingersite.com/$rawPath';
        }

        return ReportContainer(
          imageUrl: imageUrl,
          name: product['name']?.toString(),
          seller: product['seller']?.toString(),
          reportCount: product['reportCount'] ?? 0,
          sellerId: product['seller_id'] ?? 0,
        );
      },
    );
  }
}

// ------------------------ ReportContainer ------------------------

class ReportContainer extends StatelessWidget {
  final String imageUrl;
  final String? name;
  final String? seller;
  final int reportCount;
  final int sellerId;

  const ReportContainer({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.seller,
    required this.reportCount,
    required this.sellerId,
  });

  @override
  Widget build(BuildContext context) {
    final bool validImage = imageUrl.isNotEmpty && imageUrl.startsWith('http');

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: validImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                    ),
                  )
                : const Icon(Icons.image_not_supported, size: 50),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text("Seller: ${seller ?? 'Unknown'}", overflow: TextOverflow.ellipsis),
                Text("Seller ID: $sellerId", overflow: TextOverflow.ellipsis),
                Text("Reports: $reportCount", overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}