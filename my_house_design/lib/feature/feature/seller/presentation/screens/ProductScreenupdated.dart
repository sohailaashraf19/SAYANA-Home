import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/presentation/widgets/color.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String categoryId;

  const EditProductScreen({
    Key? key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
  }) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _priceController = TextEditingController(text: widget.price);
    _quantityController = TextEditingController(text: widget.quantity);
    _categoryController = TextEditingController(text: widget.categoryId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    try {
      final response = await updateProduct(
        productId: widget.productId,
        name: _nameController.text,
        description: _descriptionController.text,
        price: _priceController.text,
        quantity: _quantityController.text,
        categoryId: _categoryController.text,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Product updated successfully')),
        );
        Navigator.pop(context); // Close the edit screen after updating
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<http.Response> updateProduct({
    required String productId,
    required String name,
    required String description,
    required String price,
    required String quantity,
    required String categoryId,
  }) async {
    final url = Uri.parse(
      'https://olivedrab-llama-457480.hostingersite.com/public/api/update_product/$productId',
    );

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN',  // Add your token if required
        },
        body: jsonEncode({
          "name": name,
          "description": description,
          "price": price,
          "quantity": quantity,
          "category_id": categoryId,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        
        title: const Text('Edit Product'),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 400),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF003664),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _updateProduct,
              child: const Text(
                'Update Product',
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
