import 'package:flutter/material.dart';

import 'package:my_house_design/feature/feature/buyer/presentation/screens/search_screen.dart';
import 'package:my_house_design/presentation/widgets/color.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarFontSize = screenWidth * 0.04;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SearchScreen()),
            );
          },
          child: AbsorbPointer(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                hintStyle: TextStyle(fontSize: searchBarFontSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}