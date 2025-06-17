import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/billing_summary_page.dart';
import 'package:my_house_design/presentation/widgets/color.dart';

class BillingAddressPage extends StatefulWidget {
  const BillingAddressPage({super.key});

  @override
  State<BillingAddressPage> createState() => _BillingAddressPageState();
}

class _BillingAddressPageState extends State<BillingAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final streetController     = TextEditingController();
  final streetNoController   = TextEditingController();
  final floorNoController    = TextEditingController();
  final buildingNoController = TextEditingController();

  bool   isSubmitting  = false;
  String errorMessage  = '';
  String paymentMethod = 'cash';

 final List<Map<String, dynamic>> cities = [
  {'id': 1, 'name': 'Cairo'},
  {'id': 2, 'name': 'Alexandria'},
  {'id': 3, 'name': 'Giza'},
  {'id': 4, 'name': 'Dakahlia'},
  {'id': 5, 'name': 'Red Sea'},
  {'id': 6, 'name': 'Beheira'},
  {'id': 7, 'name': 'Fayoum'},
  {'id': 8, 'name': 'Gharbia'},
  {'id': 9, 'name': 'Ismailia'},
  {'id': 10, 'name': 'Menofia'},
  {'id': 11, 'name': 'Minya'},
  {'id': 12, 'name': 'Qalyubia'},
  {'id': 13, 'name': 'New Valley'},
  {'id': 14, 'name': 'Suez'},
  {'id': 15, 'name': 'Aswan'},
  {'id': 16, 'name': 'Assiut'},
  {'id': 17, 'name': 'Beni Suef'},
  {'id': 18, 'name': 'Port Said'},
  {'id': 19, 'name': 'Dumyat'},
  {'id': 20, 'name': 'Sharqia'},
  {'id': 21, 'name': 'South Sinai'},
  {'id': 22, 'name': 'Kafr El Sheikh'},
  {'id': 23, 'name': 'Matrouh'},
  {'id': 24, 'name': 'Luxor'},
  {'id': 25, 'name': 'Qena'},
  {'id': 26, 'name': 'North Sinai'},
  {'id': 27, 'name': 'Sohag'},
];

  int?    selectedCityId;
  String? selectedCityName;
  XFile?  instapayImage;

  /* ---------------------------  SUBMIT  --------------------------- */
  Future<void> submitAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { isSubmitting = true; errorMessage = ''; });

    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) {
      setState(() { errorMessage = 'Buyer ID not found'; isSubmitting = false; });
      return;
    }
    if (selectedCityName == null) {
      setState(() { errorMessage = 'Please select a city.'; isSubmitting = false; });
      return;
    }

    /* ---- حقول مشتركة ---- */
    final Map<String, String> fields = {
      'street'        : streetController.text,
      'street_no'     : streetNoController.text,
      'building_no'   : buildingNoController.text,
      'floor_no'      : floorNoController.text,
      'payment_method': paymentMethod,           // 🔑 فيه مسافة
      'city_name'     : selectedCityName!,
      'buyer_id'      : buyerId.toString(),
      'offer'         : '0',
    };

    final url = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/neworders');

    http.Response response;
    try {
      if (paymentMethod == 'cash') {
        /* ---------- JSON (Cash) ---------- */
        response = await http.post(
          url,
          headers: {
            'Accept'       : 'application/json',
            'Content-Type' : 'application/json',
          },
          body: jsonEncode(fields),
        );
      } else {
        /* ---------- Multipart (InstaPay) ---------- */
        if (instapayImage == null) {
          setState(() { errorMessage = 'Please upload transaction image.'; isSubmitting = false; });
          return;
        }

        final req = http.MultipartRequest('POST', url)
          ..fields.addAll(fields)
          ..files.add(await http.MultipartFile.fromPath(
              'img',                                   // 🔑 كما في Postman
              instapayImage!.path,
              filename: instapayImage!.name));

        final streamed = await req.send();
        response = await http.Response.fromStream(streamed);
      }

      /* ---------- معالجة الاستجابة ---------- */
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body  : ${response.body}');
      if (response.statusCode == 200) {
        final data    = jsonDecode(response.body);
        final orderId = data['order']?['id'];
        if (orderId != null) {
          await CacheHelper.saveData(key: 'orderId', value: orderId);
          if (!mounted) return;
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const BillingSummaryPage()));
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Address submitted successfully!')));
        } else {
          setState(() => errorMessage = 'Order ID not found in response.');
        }
      } else {
        setState(() => errorMessage =
            'Failed (${response.statusCode}). ${response.reasonPhrase ?? ''}');
      }
    } catch (e) {
      setState(() => errorMessage = 'An error occurred: $e');
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  /* ---------------------------  UI  --------------------------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Billing Address', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003664),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please provide your billing details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,)),
                const SizedBox(height: 20),
                
                _buildInputField(Icons.location_on, 'Street', streetController),
                _buildInputField(Icons.location_on, 'Street Number', streetNoController),
                _buildInputField(Icons.location_on, 'Floor Number', floorNoController),
                _buildInputField(Icons.location_on, 'Building Number', buildingNoController),
                const SizedBox(height: 20),

                /* ---- Payment Method ---- */
                const Text('Choose Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(children: [
                  Radio<String>(
                      value: 'cash',
                        activeColor: Color(0xFF003664), // ← أزرق

                      groupValue: paymentMethod,
                      onChanged: (v) => setState(() => paymentMethod = v!)),
                  const Text('Cash'),
                  Radio<String>(
                      value: 'instapay',
                        activeColor: Color(0xFF003664), // ← أزرق

                      groupValue: paymentMethod,
                      onChanged: (v) => setState(() => paymentMethod = v!)),
                  const Text('InstaPay'),
                ]),

                /* ---- City ---- */
                const SizedBox(height: 20),
                const Text('Select Your City',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  value: selectedCityId,
                  items: cities
                      .map((c) => DropdownMenuItem<int>(value: c['id'], child: Text(c['name'])))
                      .toList(),
                  onChanged: (v) {
                    final city = cities.firstWhere((c) => c['id'] == v);
                    setState(() {
                      selectedCityId   = v;
                      selectedCityName = city['name'];
                    });
                  },
                  validator: (v) => v == null ? 'Please select a city' : null,
                ),

                /* ---- InstaPay Image ---- */
                if (paymentMethod == 'instapay') ...[
                  const SizedBox(height: 20),
                  const Text('Transfer to InstaPay Account: 010‑XXXX‑XXXX',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 0, 0, 0))),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload, color: Colors.black),
                    label: Text(instapayImage == null ? 'Upload Transaction Image' : 'Change Image',style: const TextStyle(color: Colors.black),),
                    
                    onPressed: () async {
                      final XFile? img =
                          await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (img != null) setState(() => instapayImage = img);
                    },
                  ),
                  if (instapayImage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.file(File(instapayImage!.path), height: 150),
                    ),
                ],

                /* ---- Error ---- */
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                  ),

                /* ---- Submit ---- */
                const SizedBox(height: 20),
                isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: submitAddress,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: const Color(0xFF003664),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ----------------------- Reusable Field ----------------------- */
  Widget _buildInputField(
      IconData icon, String label, TextEditingController controller) {
    return Card(
      color: boxColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Icon(icon, color: const Color(0xFF003664), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: label, border: InputBorder.none),
              validator: (v) => v == null || v.isEmpty ? '$label is required' : null,
            ),
          ),
        ]),
      ),
    );
  }
}
