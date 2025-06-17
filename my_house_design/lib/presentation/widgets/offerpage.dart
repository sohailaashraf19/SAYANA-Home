import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/presentation/widgets/color.dart';
import 'dart:convert';
import '../../feature/feature/buyer/presentation/screens/pdPage.dart'; // Import your ProductDetailPage

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<dynamic> offers = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOffersData();
  }

  Future<void> fetchOffersData() async {
    try {
      final response =
          await http.get(Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/showalloffer'));
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          offers = data.take(100).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products: ${response.statusCode}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Offers"),
        backgroundColor: backgroundColor,
        ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : offers.isEmpty
              ? Center(
                  child: Text(
                    errorMessage.isEmpty ? "No products available" : errorMessage,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 per row
                      childAspectRatio: 0.75, // Adjust height
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];

                      final productName =
                          offer['name'] != null ? offer['name'].toString() : 'No Name';
                      final productPrice =
                          offer['price'] != null ? offer['price'].toString() : 'N/A';
                      final description =
                          offer['description'] != null ? offer['description'].toString() : '';
                                                final productId = offer['product_id'] != null ? int.tryParse(offer['product_id'].toString()) : null; // Nullable int

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
                                description: description, productId: productId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
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
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                                  "\$$productPrice",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
