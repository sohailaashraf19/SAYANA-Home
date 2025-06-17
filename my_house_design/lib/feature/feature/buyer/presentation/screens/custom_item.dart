import 'package:flutter/material.dart';

class CustomItem extends StatelessWidget {
  const CustomItem({super.key, required this.name, required this.image});
  final String name, image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: 60,  // Increased size
            height: 60, // Increased size
            decoration: BoxDecoration(
              color: Color(0xFF003664),
              shape: BoxShape.circle, // Makes it circular
            ),
            child: Center(
              child: Image.asset(
                image,
                height: 40, // Increased image size
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(fontFamily: "Sansita", fontSize: 14)),
        ],
      ),
    );
  }
}
