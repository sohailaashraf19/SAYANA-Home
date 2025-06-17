import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const navyBlue = Color(0xFF003664); // Your navy blue color

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: navyBlue,
        title: const Text('Help & Support'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Need Help?",
              style: TextStyle(
                color: navyBlue,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "If you're experiencing any problems, feel free to reach out to us through the following contact options:",
              style: TextStyle(
                color: navyBlue.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Icon(Icons.email, color: navyBlue),
                const SizedBox(width: 10),
                Text(
                  "syana289289@gmail.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: navyBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.phone, color: navyBlue),
                const SizedBox(width: 10),
                Text(
                  "+20 123 456 7890",
                  style: TextStyle(
                    fontSize: 16,
                    color: navyBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
        
          ],
        ),
      ),
    );
  }
}
