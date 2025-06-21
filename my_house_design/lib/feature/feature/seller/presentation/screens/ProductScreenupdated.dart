import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/presentation/widgets/color.dart'; // backgroundColor & boxColor

class EditProductScreen extends StatefulWidget {
  final String productId;
  final String name;
  final String description;
  final String price;
  final String quantity;
  final String categoryId;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _catIdCtrl;

  /* -------------------- Lifecycle -------------------- */
  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: widget.name);
    _descCtrl  = TextEditingController(text: widget.description);
    _priceCtrl = TextEditingController(text: widget.price);
    _qtyCtrl   = TextEditingController(text: widget.quantity);
    _catIdCtrl = TextEditingController(text: widget.categoryId);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _catIdCtrl.dispose();
    super.dispose();
  }

  /* --------------------- Helpers --------------------- */
  void _snack(String m, {bool err = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(m),
          backgroundColor: err ? Colors.red[600] : Colors.green[600],
        ),
      );

  Widget _cardField({
    required IconData icon,
    required String label,
    required TextEditingController ctrl,
    TextInputType kb = TextInputType.text,
    int lines = 1,
  }) {
    return Card(
      color: boxColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF003664), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: ctrl,
                keyboardType: kb,
                maxLines: lines,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? '$label is required' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* --------------------- Network --------------------- */
  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final uri = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/update_product/${widget.productId}');
    try {
      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN', // replace if needed
        },
        body: jsonEncode({
          "name"       : _nameCtrl.text,
          "description": _descCtrl.text,
          "price"      : _priceCtrl.text,
          "quantity"   : _qtyCtrl.text,
          "category_id": _catIdCtrl.text,
        }),
      );

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _snack(json['message'] ?? 'Product updated successfully');
        Navigator.pop(context, true); // return to previous screen
      } else {
        _snack(
          json['message'] ?? 'Failed to update product (code ${res.statusCode})',
          err: true,
        );
      }
    } catch (e) {
      _snack('Unexpected error: $e', err: true);
    }
  }

  /* ----------------------- UI ----------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Product', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003664),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Modify product details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              _cardField(icon: Icons.text_fields, label: 'Name', ctrl: _nameCtrl),
              _cardField(
                  icon: Icons.description,
                  label: 'Description',
                  ctrl: _descCtrl,
                  lines: 3),
              _cardField(
                  icon: Icons.attach_money,
                  label: 'Price',
                  ctrl: _priceCtrl,
                  kb: TextInputType.number),
              _cardField(
                  icon: Icons.numbers,
                  label: 'Quantity',
                  ctrl: _qtyCtrl,
                  kb: TextInputType.number),
              _cardField(
                  icon: Icons.category,
                  label: 'Category ID',
                  ctrl: _catIdCtrl,
                  kb: TextInputType.number),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003664),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Update Product',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}