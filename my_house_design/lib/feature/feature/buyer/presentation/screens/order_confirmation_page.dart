import 'package:flutter/material.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';
import 'cart_page.dart';
import '../../../../../presentation/widgets/color.dart';
import '../../../../../presentation/widgets/functions.dart';
import 'custom_icon_button.dart';
import '../../../../../presentation/widgets/text_style.dart';
import 'SettingsPage.dart';
import 'all_categories_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConfirmOrderPage(),
    );
  }
}

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key});

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<ConfirmOrderPage> {
  int currentIndex = 3; // البداية من الايقونة home

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () {
            Navigator.pop(context);
          },  
        ),
        actions: [
          CustomIconButton(
            icon: Icons.shopping_cart,
            iconColor: iconColor,
            hasBadge:
                false, //cartItems.where((item) => item['selected']).isNotEmpty,
            onPressed: () => navigateTo(context, CartPage()),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Thank You For Your Order !",
                  style: headingshadowTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Your Order has been placed please check the delivery status at",
                  textAlign: TextAlign.center,
                  style: normal14TextStyle,
                ),
                Text(
                  "Order Tracking",
                  style: bold14TextStyle,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF003664),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                    );
                  },
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            setState(() {
              currentIndex = index;
            });

            // Navigate to the corresponding page
            Widget destination;
            switch (index) {
              case 0:
                destination = AllCategoriesPage();
                break;
              case 1:
                destination = WishlistPage();
                break;
              case 2:
                destination = HomeView();
                break;
              case 3:
                destination = HomeScreen();
                break;
              case 4:
                destination = SettingsPage();
                break;
              default:
                destination = HomeView();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        items: [
          navitem(
              icon: Icons.grid_view,
              label: "Category",
              index: 0,
              currentIndex: currentIndex),
          navitem(
              icon: Icons.favorite_border,
              label: "Wishlist",
              index: 1,
              currentIndex: currentIndex),
          navitem(
              icon: Icons.home,
              label: "Home",
              index: 2,
              currentIndex: currentIndex),
                    navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),

          navitem(
              icon: Icons.settings,
              label: "Settings",
              index: 4,
              currentIndex: currentIndex),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
