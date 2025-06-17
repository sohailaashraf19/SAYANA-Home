import 'package:flutter/material.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/profile_page.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/cart_page.dart';


class AppBarHome extends StatelessWidget {
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Set the font size as a proportion of the screen width for better scalability
    double titleFontSize = screenWidth * 0.06;  // Adjust the title font size based on screen width
    double subtitleFontSize = screenWidth * 0.04; // Adjusted subtitle font size for better visibility

    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: screenHeight * 0.20, // Height remains as per the initial setup
            color: const Color(0xFF003664),
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.05, // Top position remains unchanged
                  left: screenWidth * 0.05,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SYANA Home",
                            style: TextStyle(
                              fontFamily: "Sansita",
                              fontSize: titleFontSize,  // Applied font size dynamically for the title
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4), // Add space between title and subtitle
                          Text(
                            "Your cozy home starts here",
                            style: TextStyle(
                              fontFamily: "Sansita",
                              fontSize: subtitleFontSize,  // Adjusted font size for subtitle
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Container(), // Remove the AppBar title, as we're handling it manually above
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              ),
              
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 15); // Reduced the curve height for compact view
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 15);
    path.quadraticBezierTo(3 * (size.width / 4), size.height - 30, size.width, size.height - 15);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
