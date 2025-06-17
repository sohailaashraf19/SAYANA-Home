import 'package:flutter/material.dart';
import 'package:admin_sayana/Screens/Login /login_page.dart';
import 'package:admin_sayana/Screens/Home/admin_home_page.dart';
import 'package:admin_sayana/Screens/Order/admin_order_page.dart';
import 'package:admin_sayana/Screens/Product/admin_product_page.dart';
import 'package:admin_sayana/Screens/Reports/admin_report_page.dart';
import 'package:admin_sayana/Screens/Voucher/admin_voucher_page.dart';
import 'package:admin_sayana/theme/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // صفحة تسجيل الدخول تظهر أولاً
    );
  }
}

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 2;

  List<Widget> get _pages => [
        const ProductPage(),
        const OrdersPage(),
        HomePage(onItemSelected: _onItemTapped),
        const ReportsPage(),
        const VouchersPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.white,
        backgroundColor: primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Voucher',
          ),
        ],
      ),
    );
  }
}