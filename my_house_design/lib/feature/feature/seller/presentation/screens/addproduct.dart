import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_house_design/presentation/widgets/color.dart'; // ← backgroundColor & boxColor

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl       = TextEditingController();
  final descCtrl       = TextEditingController();
  final priceCtrl      = TextEditingController();
  final qtyCtrl        = TextEditingController();
  final catIdCtrl      = TextEditingController();
  final salesCtrl      = TextEditingController(text: '0');
  final colorCtrl      = TextEditingController();
  final typeCtrl       = TextEditingController();
  final discountCtrl   = TextEditingController(text: '0');

  File?   imageFile;
  String? sellerId;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadCached();
  }

  Future<void> _loadCached() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sellerId = prefs.getString('seller_id');
      token    = prefs.getString('token');
    });
  }

  /* --------------------- Helpers --------------------- */
  void _snack(String m, {bool err = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(m),
          backgroundColor: err ? Colors.red[600] : Colors.green[600],
        ),
      );

  Future<void> _pickImage() async {
    final XFile? picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  /* --------------------- Submit --------------------- */
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (sellerId == null) {
      _snack('Seller ID not found. Please log in.', err: true);
      return;
    }
    if (imageFile == null) {
      _snack('Please select an image.', err: true);
      return;
    }

    final uri = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/add_product');
    final req = http.MultipartRequest('POST', uri)
      ..fields.addAll({
        'name'       : nameCtrl.text,
        'description': descCtrl.text,
        'price'      : priceCtrl.text,
        'quantity'   : qtyCtrl.text,
        'category_id': catIdCtrl.text,
        'saller_id'  : sellerId!,
        'sales_count': salesCtrl.text,
        'color'      : colorCtrl.text,
        'type'       : typeCtrl.text,
        'discount'   : discountCtrl.text,
      })
      ..files.add(await http.MultipartFile.fromPath('images', imageFile!.path));

    if (token != null) req.headers['Authorization'] = 'Bearer $token';

    try {
      final res   = await req.send();
      final body  = await res.stream.bytesToString();
      final json  = jsonDecode(body);
      final okMsg = json['message']?.toString().toLowerCase().contains('success') ?? false;

      if (okMsg) {
        _snack('✅ Product added successfully!');
        Navigator.pop(context, true);            // notify ProductScreen
      } else {
        _snack('❌ ${json['message'] ?? 'Failed to add product'}', err: true);
      }
    } catch (e) {
      _snack('❌ Unexpected error: $e', err: true);
    }
  }

  /* ------------------- Input Card ------------------- */
  Widget _cardField(
      {required IconData icon,
      required String label,
      required TextEditingController ctrl,
      TextInputType kb = TextInputType.text,
      int lines = 1}) {
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

  /* ----------------------- UI ----------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003664),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: sellerId == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter product details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    _cardField(icon: Icons.text_fields, label: 'Name', ctrl: nameCtrl),
                    _cardField(
                        icon: Icons.description,
                        label: 'Description',
                        ctrl: descCtrl,
                        lines: 3),
                    _cardField(
                        icon: Icons.attach_money,
                        label: 'Price',
                        ctrl: priceCtrl,
                        kb: TextInputType.number),
                    _cardField(
                        icon: Icons.numbers,
                        label: 'Quantity',
                        ctrl: qtyCtrl,
                        kb: TextInputType.number),
                    _cardField(
                        icon: Icons.category,
                        label: 'Category ID',
                        ctrl: catIdCtrl,
                        kb: TextInputType.number),
                    _cardField(
                        icon: Icons.bar_chart,
                        label: 'Sales Count',
                        ctrl: salesCtrl,
                        kb: TextInputType.number),
                    _cardField(icon: Icons.color_lens, label: 'Color', ctrl: colorCtrl),
                    _cardField(icon: Icons.label, label: 'Type', ctrl: typeCtrl),
                    _cardField(
                        icon: Icons.discount,
                        label: 'Discount',
                        ctrl: discountCtrl,
                        kb: TextInputType.number),

                    const SizedBox(height: 12),

                    /* -------------- Image Picker -------------- */
                    Card(
                      color: boxColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.image,
                                    color: Color(0xFF003664), size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    imageFile == null
                                        ? 'No image selected'
                                        : imageFile!.path.split('/').last,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _pickImage,
                                  child: const Text('Choose Image'),
                                )
                              ],
                            ),
                            if (imageFile != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Image.file(imageFile!, height: 120),
                              )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /* -------------- Submit Button -------------- */
                    Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003664),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Add Product',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    qtyCtrl.dispose();
    catIdCtrl.dispose();
    salesCtrl.dispose();
    colorCtrl.dispose();
    typeCtrl.dispose();
    discountCtrl.dispose();
    super.dispose();
  }
}