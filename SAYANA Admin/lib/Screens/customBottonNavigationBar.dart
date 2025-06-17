import 'package:admin_sayana/Screens/Order/admin_order_page.dart';
import 'package:admin_sayana/Screens/Reports/admin_report_page.dart';
import 'package:admin_sayana/Screens/Voucher/admin_voucher_page.dart';
import 'package:flutter/material.dart';


class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 2;
  late PageController _pageController;

  final List<Widget> _pages = [
    SizedBox(), // ProductsPage(),
    OrdersPage(),
    SizedBox(),// HomePage(),
    ReportsPage(),
    VouchersPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.inventory_2,
      Icons.shopping_cart,
      Icons.home,
      Icons.bar_chart,
      Icons.confirmation_number,
    ];
    final labels = ['Products', 'Orders', 'Home', 'Reports', 'Voucher'];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xffB4ABA2),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons[index],
                      color: isSelected ? Colors.white : Colors.white70),
                  SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 239, 233, 226),
    );
  }
}