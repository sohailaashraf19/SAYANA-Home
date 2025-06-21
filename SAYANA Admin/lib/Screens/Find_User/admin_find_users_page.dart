import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_sayana/theme/color.dart'; // backgroundColor, boxColor, primaryColor
import 'package:admin_sayana/Screens/Home/admin_home_page.dart'; // تأكد من المسار الصحيح

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AdminFindUserPage(),
    );
  }
}

class AdminFindUserPage extends StatefulWidget {
  const AdminFindUserPage({super.key});

  @override
  State<AdminFindUserPage> createState() => _AdminFindUserPageState();
}

class _AdminFindUserPageState extends State<AdminFindUserPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _searchController.addListener(() => searchUsers(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
      /* -----------------  Buyers  ----------------- */
      final buyersResponse = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getAllBuyers'),
      );

      final List<Map<String, dynamic>> buyers = [];
      if (buyersResponse.statusCode == 200) {
        final dynamic buyersDecoded = jsonDecode(buyersResponse.body);
        late final List<dynamic> buyersData;

        if (buyersDecoded is Map && buyersDecoded.containsKey('data')) {
          buyersData = buyersDecoded['data'];
        } else if (buyersDecoded is List) {
          buyersData = buyersDecoded;
        } else {
          throw Exception('Unexpected buyers response format');
        }

        buyers.addAll(buyersData.map((buyer) => {
              'id': buyer['buyer_id'],
              'name': buyer['name'],
              'email': buyer['email'],
              'phone': buyer['phone'],
              'type': 'Customer',
              'reports': 0,
            }));
      } else {
        throw Exception('Failed to load buyers: ${buyersResponse.statusCode}');
      }

      /* -----------------  Sellers  ----------------- */
      final sellersResponse = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/allseller'),
      );

      final List<Map<String, dynamic>> sellers = [];
      if (sellersResponse.statusCode == 200) {
        final dynamic sellersDecoded = jsonDecode(sellersResponse.body);
        late final List<dynamic> sellersData;

        if (sellersDecoded is Map && sellersDecoded.containsKey('sellers')) {
          sellersData = sellersDecoded['sellers'];
        } else if (sellersDecoded is List) {
          sellersData = sellersDecoded;
        } else {
          throw Exception('Unexpected sellers response format');
        }

        sellers.addAll(sellersData.map((seller) => {
              'id': seller['seller_id'],
              'name': seller['brand_name'],
              'email': seller['email'],
              'phone': seller['phone'],
              'type': 'Seller',
              'reports': 0,
            }));
      } else {
        throw Exception('Failed to load sellers: ${sellersResponse.statusCode}');
      }

      setState(() {
        users = [...buyers, ...sellers];
        applyFilter(selectedFilter);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  /* -----------------  Filters & Search  ----------------- */

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Customers') {
        filteredUsers = users.where((u) => u['type'] == 'Customer').toList();
      } else if (filter == 'Sellers') {
        filteredUsers = users.where((u) => u['type'] == 'Seller').toList();
      } else {
        filteredUsers = List<Map<String, dynamic>>.from(users);
      }
      if (_searchController.text.isNotEmpty) {
        searchUsers(_searchController.text, updateState: false);
      }
    });
  }

  void searchUsers(String query, {bool updateState = true}) {
    List<Map<String, dynamic>> baseList;
    if (selectedFilter == 'Customers') {
      baseList = users.where((u) => u['type'] == 'Customer').toList();
    } else if (selectedFilter == 'Sellers') {
      baseList = users.where((u) => u['type'] == 'Seller').toList();
    } else {
      baseList = List<Map<String, dynamic>>.from(users);
    }
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      filteredUsers = baseList.where((u) {
        return (u['name'] ?? '').toString().toLowerCase().contains(q) ||
            (u['email'] ?? '').toString().toLowerCase().contains(q) ||
            (u['phone'] ?? '').toString().toLowerCase().contains(q);
      }).toList();
    } else {
      filteredUsers = baseList;
    }
    if (updateState) setState(() {});
  }

  /* -----------------  UI  ----------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: primaryColor),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage(onItemSelected: (_) {})),
              (route) => false,
            );
          },
        ),
        title: const Text(
          "Users",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /* -----------------  Search & Filter  ----------------- */
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by name, email, or phone...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      icon: const Icon(Icons.filter_list, color: Colors.black),
                      dropdownColor: const Color(0xFFFBFBFB),
                      items: ['All', 'Customers', 'Sellers']
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => v != null ? applyFilter(v) : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            /* -----------------  List  ----------------- */
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredUsers.isEmpty
                      ? const Center(child: Text('No users match the filter or search'))
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, i) {
                            final u = filteredUsers[i];
                            return Card(
                              color: boxColor,
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ${u['name']}'),
                                    Text('Email: ${u['email']}'),
                                    if (u['phone'] != null) Text('Phone: ${u['phone']}'),
                                    Text('Account Type: ${u['type']}'),
                                    // Deactivate button removed as requested
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}