import 'package:flutter/material.dart';

BottomNavigationBarItem navitem({
  required IconData icon,
  required String label,
  required int index,
  required int currentIndex,
}) {
  return BottomNavigationBarItem(
    // Set the background color to blue for consistency
    backgroundColor: Color(0xFF003664), 

    icon: Icon(
      icon,
      size: 24, // Adjusted icon size for compact screens
      color: currentIndex == index
          ? const Color.fromARGB(255, 255, 255, 255) // Selected color (white)
          : Colors.white, // Unselected color (white)
    ),
    label: label,
    tooltip: label, // Add tooltip for accessibility
  );
}
