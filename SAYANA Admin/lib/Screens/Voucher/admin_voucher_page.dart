import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admin_sayana/theme/color.dart'; // تأكد أن هذا الملف يحتوي الألوان المطلوبة

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const VouchersPage(),
    );
  }
}

class VouchersPage extends StatefulWidget {
  const VouchersPage({super.key});

  @override
  _VouchersPageState createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  List<Map<String, dynamic>> vouchers = [];

  @override
  void initState() {
    super.initState();
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/showalloffer');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List offers = json.decode(response.body);
        setState(() {
          vouchers = offers.map<Map<String, dynamic>>((offer) {
            return {
              'title': offer['title']?.toString() ?? '',
              'description': offer['description']?.toString() ?? '',
              'discount': offer['discount']?.toString() ?? '',
              'start_date': offer['start_date']?.toString() ?? '',
              'end_date': offer['end_date']?.toString() ?? '',
              'img': offer['img']?.toString() ?? '',
              'id': offer['id']?.toString() ?? '',
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء تحميل العروض')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الاتصال بالسيرفر')),
      );
    }
  }

  Future<void> addVoucherToApi(Map<String, dynamic> voucherData) async {
    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/addnewofferadmin');
    try {
      final response = await http.post(
        url,
        body: voucherData,
      );
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status: ${response.statusCode}\nBody: ${response.body}')),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Promo code added successfully')),
        );
        fetchVouchers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add promo code')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الاتصال بالسيرفر')),
      );
    }
  }

  Future<void> deleteVoucherFromApi(String id, int index) async {
    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/deletoffer/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          vouchers.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not deleted. An error occurred!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to connect to server')),
      );
    }
  }

  void deleteVoucher(int index, String id) {
    deleteVoucherFromApi(id, index);
  }

  Future<void> updateVoucherApi(String id, Map<String, dynamic> updatedData, int index) async {
    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/updateoffer/$id');
    try {
      final response = await http.post(
        url,
        body: updatedData,
      );
      if (response.statusCode == 200) {
        setState(() {
          vouchers[index] = {
            ...vouchers[index],
            ...updatedData,
          };
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update failed!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to connect to server')),
      );
    }
  }

  void showAddVoucherDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController discountController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: boxColor,
          title: const Text('Add New Voucher'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: discountController,
                  decoration: const InputDecoration(labelText: 'Discount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date (yyyy-mm-dd)'),
                ),
                TextField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: 'End Date (yyyy-mm-dd)'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final voucherData = {
                  'title': titleController.text,
                  'discount': discountController.text,
                  'start_date': startDateController.text,
                  'end_date': endDateController.text,
                };
                Navigator.pop(context);
                addVoucherToApi(voucherData);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showUpdateDialog(int index, Map<String, dynamic> voucher) {
    final TextEditingController titleController = TextEditingController(text: voucher['title']);
    final TextEditingController descriptionController = TextEditingController(text: voucher['description']);
    final TextEditingController discountController = TextEditingController(text: voucher['discount']);
    final TextEditingController startDateController = TextEditingController(text: voucher['start_date']);
    final TextEditingController endDateController = TextEditingController(text: voucher['end_date']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: boxColor,
          title: const Text('Update Voucher'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: discountController, decoration: const InputDecoration(labelText: 'Discount')),
                TextField(controller: startDateController, decoration: const InputDecoration(labelText: 'Start Date')),
                TextField(controller: endDateController, decoration: const InputDecoration(labelText: 'End Date')),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final updatedData = {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'discount': discountController.text,
                  'start_date': startDateController.text,
                  'end_date': endDateController.text,
                };
                Navigator.pop(context);
                updateVoucherApi(voucher['id'], updatedData, index);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: const Vouchercustomappbar(
            image: 'assets/SYANA HOME.png',
            text: 'Vouchers',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: primaryColor, size: 32),
              onPressed: showAddVoucherDialog,
              tooltip: 'Add New Voucher',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                VoucherContainer(
                  vouchers: vouchers,
                  onDelete: deleteVoucher,
                  onUpdate: (index, voucher) => showUpdateDialog(index, voucher),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Vouchercustomappbar extends StatelessWidget {
  const Vouchercustomappbar({super.key, required this.image, required this.text});
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.red,
          radius: 35,
          backgroundImage: AssetImage(image),
        ),
        const Spacer(),
        Text(
          text,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class Voucher_Detailed extends StatelessWidget {
  const Voucher_Detailed({
    super.key,
    required this.title,
    required this.discount,
    required this.startDate,
    required this.endDate,
    required this.onDelete,
    required this.description,
    required this.img,
    required this.onUpdate,
  });
  final String title;
  final String discount;
  final String startDate;
  final String endDate;
  final String description;
  final String img;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة ممكن إضافتها لو حبيت
            const SizedBox(width: 0, height: 0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (description.isNotEmpty && description != title)
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.black87),
                    ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      if (discount.isNotEmpty && discount != "0")
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            '$discount%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      if (startDate.isNotEmpty)
                        Text(
                          '       from: ${startDate.split(' ').first}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      const SizedBox(width: 5),
                      if (endDate.isNotEmpty)
                        Text(
                          '       to: ${endDate.split(' ').first}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onUpdate,
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Color(0xffD20800)),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherContainer extends StatelessWidget {
  const VoucherContainer({
    super.key,
    required this.vouchers,
    required this.onDelete,
    required this.onUpdate,
  });
  final List<Map<String, dynamic>> vouchers;
  final Function(int, String) onDelete;
  final Function(int, Map<String, dynamic>) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: vouchers.isEmpty
          ? const Center(child: Text('No vouchers available'))
          : Column(
              children: List.generate(
                vouchers.length,
                (index) => Voucher_Detailed(
                  title: vouchers[index]['title'] ?? '',
                  description: vouchers[index]['description'] ?? '',
                  discount: vouchers[index]['discount'] ?? '',
                  startDate: vouchers[index]['start_date'] ?? '',
                  endDate: vouchers[index]['end_date'] ?? '',
                  img: vouchers[index]['img'] ?? '',
                  onDelete: () => onDelete(index, vouchers[index]['id']),
                  onUpdate: () => onUpdate(index, vouchers[index]),
                ),
              ),
            ),
    );
  }
}