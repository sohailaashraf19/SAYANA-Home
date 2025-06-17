import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/presentation/views/seller_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? errorMessage;


  Future<void> fetchProfile() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
      
    });

    final token = await CacheHelper.getData(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/seller/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        nameController.text = data['brand_name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
      } else {
        errorMessage = 'Failed to load profile';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.put(
    Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/seller/profile'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
    body: {
      'brand_name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
    },
  );

  if (response.statusCode == 200) {
    // ✅ Save updated name
    await prefs.setString('userName', nameController.text.trim());

    // ✅ Return "true" to refresh name in Settings
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update: ${response.statusCode}')),
    );
  }
}


  @override
  void initState() {
    super.initState();
    fetchProfile();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF003664),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SellerHomePage()),
            );
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/4537028.png'),
                        ),
                        SizedBox(height: 20),
                        _buildInputField(Icons.person, 'Brand Name', nameController),
                        _buildInputField(Icons.email, 'Email', emailController),
                        _buildInputField(Icons.phone, 'Phone', phoneController),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF003664)),
                          child: _isSaving
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Save', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInputField(IconData icon, String label, TextEditingController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF003664)),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
