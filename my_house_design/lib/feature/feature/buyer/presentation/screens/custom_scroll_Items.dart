import 'package:flutter/material.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/All%20Furniture.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/category_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/custom_item.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';

class CustomScrollItems extends StatefulWidget {
  const CustomScrollItems({super.key});

  @override
  State<CustomScrollItems> createState() => _CustomScrollItemsState();
}

class _CustomScrollItemsState extends State<CustomScrollItems> {
  final List<Map<String, dynamic>> selectedCategories = [
    {"id": "", "name": "All Furniture", "image": "assets/images/1.png"},
    {"id": "1", "name": "Bed Room", "image": "assets/images/bed room.png"},
    {"id": "8", "name": "Electronics", "image": "assets/images/2.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedCategories.length + 1, // +1 for "Show All"
        itemBuilder: (context, index) {
          if (index < selectedCategories.length) {
            final category = selectedCategories[index];
            return GestureDetector(
              onTap: () {
                if (category["name"] == "All Furniture") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllFurniture(),
                    ),
                  );
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
          } else {
            // Show All
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCategoriesPage(),
                  ),
                );
              },
              child: const Center(
                child: CustomItem(
                  name: "Show All",
                  image: "assets/images/list-16.png",
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
