import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final double fontSize; // Font size for the search text

  const CustomSearchBar({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust the height of the search bar based on the screen width for better compactness
    double searchBarHeight = screenWidth * 0.08; // Set height relative to the screen width
    double searchIconSize = screenWidth * 0.05;  // Adjust icon size proportionally

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14), // Margin for proper alignment
      width: double.infinity,
      height: searchBarHeight, // Height adjusts based on screen width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Rounded corners for compact look
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4, // Subtle shadow
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(fontSize: fontSize), // Font size is passed from the parent
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16), // Adjusted padding for alignment
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: fontSize, // Set the hint text size same as input text
          ),
          border: InputBorder.none, // Remove default border
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 255, 255, 255), width: 2), // Border when focused
            borderRadius: BorderRadius.circular(25), // Rounded corners on focus
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 2), // Default border
            borderRadius: BorderRadius.circular(25), // Rounded corners
          ),
          icon: Icon(Icons.search, color: Colors.grey, size: searchIconSize), // Adjusted icon size
        ),
      ),
    );
  }
}
