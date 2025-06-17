import 'package:flutter/material.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/choose_role_screen.dart';
import 'app_bare_home.dart';
import 'custom_scroll_Imges.dart';
import 'custom_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 2;

  final List<Map<String, String>> selectedCategories = [
    {"id": "", "name": "All Furniture", "image": "assets/images/1.png"},
    {"id": "1", "name": "Bed Room", "image": "assets/images/bed room.png"},
    {"id": "8", "name": "Electronics", "image": "assets/images/2.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarHome(),
              const SizedBox(height: 10),
              CustomScrollImages(
                imageUrlList: [
                  "assets/images/image-1740173095228.jpg",
                  "assets/images/Amazon-PaisaWapas-Deal-copy-3.webp",
                  "assets/images/image-1738880758878.jpg",
                ],
                autoPlay: true,
                height: screenWidth * 0.5, // Responsive image height
              ),
              const SizedBox(height: 20),
              const Text(
                "Categories",
                style: TextStyle(fontFamily: "Sansita", fontSize: 26),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: selectedCategories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseRoleScreen()),
                      );
                    },
                    child: SizedBox(
                      width: screenWidth / 3 - 20, // Responsive width
                      child: CustomItem(
                        name: category['name']!,
                        image: category['image']!,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                "Best Deals",
                style: TextStyle(fontFamily: "Sansita", fontSize: 26),
              ),
              const SizedBox(height: 10),
              BestItemGrid(
                products: [
                  {
                    'name': 'Sofa Set',
                    'image': 'assets/images/ffbae22916e579ef40fe61c6d16f8d66.png',
                    'price': '\2299 EGP',
                  },
                  {
                    'name': 'Dining Table',
                    'image': 'assets/images/img table 92.1.PNG',
                    'price': '\3699 EGP',
                  },
                  {
                    'name': 'Office Chair',
                    'image': 'assets/images/office.png',
                    'price': '\1099 EGP',
                  },
                  {
                    'name': 'Bed Frame',
                    'image': 'assets/images/bed 4.1.png',
                    'price': '\1349 EGP',
                  },
                ],
              ),
            ],
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

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChooseRoleScreen()),
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BestItemGrid extends StatelessWidget {
  final List<Map<String, String>> products;

  const BestItemGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChooseRoleScreen()),
            );
          },
          child: Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      product['image']!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['name']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['price']!,
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 20, 85, 197) ,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
