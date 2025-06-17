import 'package:flutter/material.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/LogoutPageSeller.dart';
import 'package:my_house_design/presentation/widgets/help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:my_house_design/presentation/views/seller_home_page.dart';

class SettingssPage extends StatefulWidget {
  const SettingssPage({super.key});
  @override
  State<SettingssPage> createState() => _SettingssPageState();
}

class _SettingssPageState extends State<SettingssPage> {
  String userName = 'Loading…';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => userName = prefs.getString('userName') ?? 'Guest');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003664),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003664),
        foregroundColor: Colors.white,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SellerHomePage()),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem(
            context,
            userName,
            Icons.person,
            () async {
              // ⬇ push and wait for a “true” flag
              final changed = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
              if (changed == true) _loadName(); // refresh UI
            },
          ),
          const SizedBox(height: 20),
          _buildItem(context, 'Home', Icons.home, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SellerHomePage()),
            );
          }),
           _buildItem(context, "Help", Icons.help, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
          }),
          // … the rest of your static items …
          const SizedBox(height: 350),
          const Divider(color: Colors.white54),
          _buildItem(context, 'Logout', Icons.logout, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SellerLogoutPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title : Text(title, style: const TextStyle(color: Colors.white)),
      onTap : onTap,
    );
  }
}

