import 'package:flutter/material.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/cart_page.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/custom_item.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/category_page.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';
import 'All Furniture.dart';

class AllCategoriesPage extends StatefulWidget {
  const AllCategoriesPage({super.key});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  int currentIndex = 0;

  final List<Map<String, String>> allCategories = [
    {"id": "", "name": "All Furniture", "image": "assets/images/1.png"},
    {"id": "70", "name": "Living Room", "image": "assets/images/3.png"},
    {"id": "1", "name": "Bed Room", "image": "assets/images/bed room.png"},
    {"id": "8", "name": "Electronics", "image": "assets/images/2.png"},
    {"id": "20", "name": "Lighter", "image": "assets/images/4.png"},
    {"id": "10", "name": "Table", "image": "assets/images/tables.png"},
    {"id": "75", "name": "office", "image": "assets/images/office.png"},
    {"id": "6", "name": "Kitchen", "image": "assets/images/kitchen.png"},
    {"id": "19", "name": "House Decore", "image": "assets/images/house decor.png"},
    {"id": "12", "name": "Door", "image": "assets/images/door.png"},
    {"id": "29", "name": "Mirrors", "image": "assets/images/mirrors.png"},
    {"id": "11", "name": "Bathroom", "image": "assets/images/5.png"},
    {"id": "2", "name": "Dining Room", "image": "assets/images/dining room.png"},
    {"id": "77", "name": "accessories", "image": "assets/images/accessories.png"},
    {"id": "15", "name": "Children Room", "image": "assets/images/bed room.png"},
    {"id": "16", "name": "carpet", "image": "assets/images/carpet.png"},
    {"id": "4", "name": "outdoors", "image": "assets/images/outdoors.png"},
    {"id": "3", "name": "wallpaper", "image": "assets/images/wallpapers.png"},
    {"id": "18", "name": "curtain", "image": "assets/images/curtain.png"},
    {"id": "30", "name": "ceramic", "image": "assets/images/bathass.png"},
  ];

  final List<Widget> pages = [
    const Placeholder(), // Will replace with grid later
    WishlistPage(),
    HomeView(),
    CartPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1000 ? 5 : screenWidth > 600 ? 4 : 3;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003664),
        title: const Text("All Categories", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: allCategories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: screenWidth > 800 ? 1.2 : 0.85,
          ),
          itemBuilder: (context, index) {
            final category = allCategories[index];
            return GestureDetector(
              onTap: () {
                if (category["name"] == "All Furniture") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AllFurniture()));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPage(
                        categoryId: category["id"]!,
                        categoryName: category["name"]!,
                      ),
                    ),
                  );
                }
              },
              child: CustomItem(
                name: category["name"]!,
                image: category["image"]!,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            setState(() => currentIndex = index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) {
                  switch (index) {
                    case 0:
                      return const AllCategoriesPage();
                    case 1:
                      return WishlistPage();
                    case 2:
                      return HomeView();
                    case 3:
                      return HomeScreen();
                    case 4:
                      return SettingsPage();
                    default:
                      return HomeView();
                  }
                },
              ),
            );
          }
        },
        items: [
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite_border, label: "Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
