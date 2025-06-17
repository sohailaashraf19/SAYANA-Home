import 'package:flutter/material.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/cart_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/LogoutPageBuyer.dart';

import 'package:my_house_design/feature/feature/buyer/presentation/screens/profile_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Method to fetch the logged-in user's name
 Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('buyerName') ?? 'Guest'; // Correct key here
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003664),
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Color(0xFF003664),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          FutureBuilder<String>(
            future: getUserName(),  // Get the user's name
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Or some loading indicator
              } else if (snapshot.hasError) {
                return Text('Error loading name');
              } else if (snapshot.hasData) {
                return _buildItem(context, snapshot.data!, Icons.person, () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ProfilePage())
                  );
                });
              } else {
                return Text('No data available');
              }
            },
          ),
          _buildItem(context, "Home", Icons.home, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
          }),
          _buildItem(context, "Category", Icons.category, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllCategoriesPage()));
          }),
          
          _buildItem(context, "Wishlist", Icons.favorite, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistPage()));
          }),
                  
          _buildItem(context, "Cart", Icons.shopping_cart, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
          }),
         
          SizedBox(height: 30,),
          Divider(color: Colors.white54),
          _buildItem(context, "Logout", Icons.logout, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LogoutPage()));
          }),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
