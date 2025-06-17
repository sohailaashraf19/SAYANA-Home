import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:admin_sayana/theme/color.dart';

void main() {
  runApp(const AdminCategoryManage());
}

class AdminCategoryManage extends StatelessWidget {
  const AdminCategoryManage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AdminCategory(),
    );
  }
}

class AdminCategory extends StatefulWidget {
  const AdminCategory({super.key});

  @override
  _AdminCategoryState createState() => _AdminCategoryState();
}

class _AdminCategoryState extends State<AdminCategory> {
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      print('Fetching categories from API...');
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getAllCategories'),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categories = data.cast<Map<String, dynamic>>().map((category) {
            String placeholderImage;
            switch (category['Name']?.toString().toLowerCase()) {
              case 'bedroom':
                placeholderImage = 'assets/bedroom.png';
                break;
              case 'dinningroom':
                placeholderImage = 'assets/diningroom.png';
                break;
              case 'wallpaper&points':
                placeholderImage = 'assets/wallpapers.png';
                break;
              case 'outdoor':
                placeholderImage = 'assets/outdoors.png';
                break;
              case 'kitchen':
                placeholderImage = 'assets/kitchen.png';
                break;
              case 'storage':
                placeholderImage = 'assets/storage.png';
                break;
              case 'electronic':
                placeholderImage = 'assets/electronic.png';
                break;
              case 'table':
                placeholderImage = 'assets/tables.png';
                break;
              case 'bathroom':
                placeholderImage = 'assets/bathass.png';
                break;
              case 'doors':
                placeholderImage = 'assets/door.png';
                break;
              case 'cheldrrien_room':
                placeholderImage = 'assets/bedroom.png';
                break;
              case 'carpet':
                placeholderImage = 'assets/carpet.png';
                break;
              case 'curtain':
                placeholderImage = 'assets/curtain.png';
                break;
              case 'house_decore':
                placeholderImage = 'assets/housedecor.png';
                break;
              case 'lighter':
                placeholderImage = 'assets/lighter.png';
                break;
              case 'mirrors':
                placeholderImage = 'assets/mirrors.png';
                break;
              case 'ceramic&porcelain':
                placeholderImage = 'assets/bathass.png';
                break;
              case 'livingroom&sofa':
                placeholderImage = 'assets/sofa.png';
                break;
              case 'office':
                placeholderImage = 'assets/office.png';
                break;
              case 'kitchen accessories&tools':
                placeholderImage = 'assets/kitchen.png';
                break;
              case 'chairs':
                placeholderImage = 'assets/chair.png';
                break;
              default:
                placeholderImage = 'assets/default_category.png';
            }
            return {
              'Category_id': category['Category_id'],
              'Name': category['Name'] ?? 'Unknown',
              'image': placeholderImage,
            };
          }).toList();
          isLoading = false;
        });
        print('Fetched categories: $categories');
      } else {
        throw Exception('Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching categories: $e';
      });
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> addCategory(String categoryName) async {
    try {
      final response = await http.post(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/addCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': categoryName}),
      );

      print('POST request sent to: https://olivedrab-llama-457480.hostingersite.com/public/api/addCategory');
      print('Request body: ${jsonEncode({'name': categoryName})}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCategories();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Category $categoryName added successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to add category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteCategory(int categoryId, String categoryName) async {
    try {
      final response = await http.delete(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/deleteCategory/$categoryId'),
      );

      print('DELETE request sent to: https://olivedrab-llama-457480.hostingersite.com/public/api/deleteCategory/$categoryId');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          categories.removeWhere((category) => category['Category_id'] == categoryId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Category $categoryName deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to delete category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> updateCategory(int categoryId, String newName) async {
    try {
      final response = await http.put(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/updateCategory/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'Name': newName}),
      );

      print('PUT request sent to: https://olivedrab-llama-457480.hostingersite.com/public/api/updateCategory/$categoryId');
      print('Request body: ${jsonEncode({'name': newName})}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          final categoryIndex = categories.indexWhere((category) => category['Category_id'] == categoryId);
          if (categoryIndex != -1) {
            categories[categoryIndex]['Name'] = newName;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Category updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating category: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showAddDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: boxColor,
          title: const Text("Add Category"),
          content: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Category Name",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  Navigator.of(context).pop();
                  addCategory(newName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category name cannot be empty"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void showUpdateDialog(int categoryId, String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);

    print('Updating category with ID: $categoryId');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: boxColor,
          title: const Text("Update Category"),
          content: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Category Name",
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  Navigator.of(context).pop();
                  updateCategory(categoryId, newName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Category name cannot be empty"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Update",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/SYANA HOME.png'),
                        ),
                        const SizedBox(width: 45),
                        const Expanded(
                          child: Text(
                            "                               Manage Category",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.black),
                          onPressed: () {
                            showAddDialog();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                          ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
                          : categories.isEmpty
                              ? const Center(child: Text("No categories found"))
                              : Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      final category = categories[index];
                                      return Card(
                                        color: boxColor,
                                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.asset(
                                                  category['image'],
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Icon(Icons.image_not_supported, size: 70);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Category Name: ${category['Name']}"),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      showUpdateDialog(category['Category_id'], category['Name']);
                                                    },
                                                    icon: const Icon(Icons.update, color: Colors.grey),
                                                    label: const Text("Update", style: TextStyle(color: Colors.grey)),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: boxColor,
                                                    ).copyWith(
                                                      overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.2)),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            backgroundColor: boxColor,
                                                            title: const Text("Delete Category"),
                                                            content: const Text("Are you sure you want to delete this Category?"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(color: primaryColor),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  deleteCategory(category['Category_id'], category['Name']);
                                                                },
                                                                child: const Text(
                                                                  "Delete",
                                                                  style: TextStyle(color: Colors.red),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(Icons.delete, color: Colors.red),
                                                    label: const Text(
                                                      "Delete",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
          ],
        ),
      ),
    );
  }
}