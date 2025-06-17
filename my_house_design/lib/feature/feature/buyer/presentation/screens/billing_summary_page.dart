import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/cart_page.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/order_confirmation_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';

class BillingSummaryPage extends StatefulWidget {
  const BillingSummaryPage({super.key});

  @override
  _BillingSummaryPageState createState() => _BillingSummaryPageState();
}

class _BillingSummaryPageState extends State<BillingSummaryPage> {
  String? orderId;
  Map<String, dynamic>? orderDetails;
  bool isLoading = true;
  int currentIndex = 3;

  @override
  void initState() {
    super.initState();
    fetchOrderId();
  }

  Future<void> fetchOrderId() async {
    final orderId = await CacheHelper.getData(key: 'orderId');
    if (orderId != null) {
      setState(() => this.orderId = orderId.toString());
      await fetchOrderDetails();
    } else {
      setState(() {
        this.orderId = 'Order ID not found';
        isLoading = false;
      });
    }
  }

  Future<void> fetchOrderDetails() async {
    if (orderId == null) return;
    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getOrderDetails/$orderId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        orderDetails = json.decode(response.body)['order'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        orderDetails = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load order details')),
      );
    }
  }

  double calculateItemsTotal() {
    double total = 0;
    for (var item in orderDetails!['order_items']) {
      final price = double.tryParse(item['price'].toString()) ?? 0;
      final qty = int.tryParse(item['quantity'].toString()) ?? 1;
      total += price * qty;
    }
    return total;
  }

  double getShippingPrice() {
    final cityId = orderDetails?['address']?['city_id'];
    final city = cities.firstWhere(
      (element) => element['id'] == cityId,
      orElse: () => {'shipping_price': 0},
    );
    return (city['shipping_price'] as num).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Billing Summary', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF003664),
        elevation: 4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderDetails == null
              ? const Center(child: Text('Failed to load order details'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('🧾 Order Summary'),
                      const SizedBox(height: 10),
                      _buildOrderDetailsCard(),

                      const SizedBox(height: 30),
                      _sectionTitle('📦 Items Ordered'),
                      const SizedBox(height: 10),
                      _buildItemsCard(),

                      const SizedBox(height: 30),
                      _sectionTitle('🚚 Shipping Address'),
                      const SizedBox(height: 10),
                      _buildAddressCard(),

                      const SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ConfirmOrderPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003664),
                            foregroundColor: Colors.white,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Confirm Order', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          setState(() => currentIndex = index);
          Widget destination;
          switch (index) {
            case 0:
              destination = AllCategoriesPage();
              break;
            case 1:
              destination = const WishlistPage();
              break;
            case 2:
              destination = const HomeView();
              break;
            case 3:
              destination = const CartPage();
              break;
            case 4:
              destination = const SettingsPage();
              break;
            default:
              destination = const HomeView();
          }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => destination));
        },
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite, label: "Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.shopping_cart, label: "My Cart", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF003664),
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
    final shipping = getShippingPrice();
    final total = calculateItemsTotal(); // 🔧 Use calculated total
    final grandTotal = total + shipping;

    return _cardContainer([
      _rowItem("Order ID", "#${orderDetails!['id']}"),
      _rowItem("Payment Method", orderDetails!['payment_method']),
      _rowItem("Items Total", "EGP ${total.toStringAsFixed(2)}"),
      _rowItem("Shipping Price", "EGP ${shipping.toStringAsFixed(2)}"),
      const Divider(),
      _rowItem("Grand Total", "EGP ${grandTotal.toStringAsFixed(2)}", isBold: true),
      _rowItem("Payment Status", orderDetails!['payment_status']),
    ]);
  }

  Widget _buildItemsCard() {
    return _cardContainer(List.generate(
      orderDetails!['order_items'].length,
      (index) {
        final item = orderDetails!['order_items'][index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['product']['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text("EGP ${item['price']} × ${item['quantity']}"),
            ],
          ),
        );
      },
    ));
  }

  Widget _buildAddressCard() {
    final address = orderDetails!['address'];
    return _cardContainer([
      Text('${address['street']}, No. ${address['street_no']}'),
      Text('Floor: ${address['floor_no']}'),
      Text('Building: ${address['building_no']}'),
    ]);
  }

  Widget _rowItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              )),
          Text(value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 15,
              )),
        ],
      ),
    );
  }

  Widget _cardContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  List<Map<String, dynamic>> cities = [
     {'id': 1, 'name': 'Cairo','shipping_price': 650},
    {'id': 2, 'name': 'Alexandria','shipping_price': 700},
    {'id': 3, 'name': 'Giza','shipping_price': 750},
    {'id': 4, 'name': 'Dakahlia','shipping_price': 800},
    {'id': 5, 'name': 'Red Sea','shipping_price': 850},
    {'id': 6, 'name': 'Beheira','shipping_price': 900},
    {'id': 7, 'name': 'Fayoum','shipping_price': 950},
    {'id': 8, 'name': 'Gharbia','shipping_price': 1000},
    {'id': 9, 'name': 'Ismailia','shipping_price': 1050},
    {'id': 10, 'name': 'Menofia','shipping_price': 1100},
    {'id': 11, 'name': 'Minya','shipping_price': 1150},
    {'id': 12, 'name': 'Qalyubia','shipping_price': 1200},
    {'id': 13, 'name': 'New Valley','shipping_price': 1250},
    {'id': 14, 'name': 'Suez','shipping_price': 1300},
    {'id': 15, 'name': 'Aswan','shipping_price': 1350},
    {'id': 16, 'name': 'Assiut','shipping_price': 1400},
    {'id': 17, 'name': 'Beni Suef','shipping_price': 1450},
    {'id': 18, 'name': 'Port Said','shipping_price': 1500},
    {'id': 19, 'name': 'Dumyat','shipping_price': 1550},
    {'id': 20, 'name': 'Sharqia','shipping_price': 1600},
    {'id': 21, 'name': 'South Sinai','shipping_price': 1650},
    {'id': 22, 'name': 'Kafr El Sheikh','shipping_price': 1700},
    {'id': 23, 'name': 'Matrouh','shipping_price': 1750},
    {'id': 24, 'name': 'Luxor','shipping_price': 1800},
    {'id': 25, 'name': 'Qena','shipping_price': 1850},
    {'id': 26, 'name': 'North Sinai','shipping_price': 1950},
    {'id': 27, 'name': 'Sohag','shipping_price': 1900},
  ];
}
