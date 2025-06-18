import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart'; // تم التبديل إلى file_picker للماك
import 'package:admin_sayana/theme/color.dart';
import 'package:admin_sayana/Screens/Home/admin_home_page.dart';

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
      final response = await http.get(
        Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getAllCategories'),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categories = data.cast<Map<String, dynamic>>().map((category) {
            String imgUrl = category['img'] ?? "";
            String? placeholderImage;
            if (imgUrl.isEmpty) {
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
            }
            return {
              'Category_id': category['Category_id'],
              'Name': category['Name'] ?? 'Unknown',
              'img': imgUrl,
              'image': placeholderImage, // could be null if img exists
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching categories: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add category with image (multipart/form-data)
  Future<void> addCategoryWithImage(String categoryName, File? imageFile) async {
    try {
      var uri = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/storeCategory');
      var request = http.MultipartRequest('POST', uri);
      request.fields['Name'] = categoryName;
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('img', imageFile.path));
      }
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchCategories();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Category $categoryName added successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Failed to add category. Status code: ${response.statusCode}, body: $respStr');
      }
    } catch (e) {
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
      final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/updateCategory/$categoryId');
      final bodyToSend = {'Name': newName};
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(bodyToSend),
      );

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add Dialog with file_picker for macOS
  void showAddDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        File? pickedImage;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: boxColor,
              title: const Text("Add Category"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
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
                  const SizedBox(height: 10),
                  pickedImage != null
                      ? Image.file(
                          pickedImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink(),
                  TextButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Pick Image"),
                    onPressed: () async {
                      print("Pick Image button pressed");
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      print("Result from file_picker: $result");
                      if (result != null && result.files.single.path != null) {
                        print("Picked image path: ${result.files.single.path}");
                        setState(() {
                          pickedImage = File(result.files.single.path!);
                        });
                      } else {
                        print("No image selected.");
                      }
                    },
                  ),
                ],
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
                      addCategoryWithImage(newName, pickedImage);
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
      },
    );
  }

  void showUpdateDialog(int categoryId, String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);

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
          "Manage Category",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: primaryColor, size: 32),
            onPressed: showAddDialog,
            tooltip: 'Add Category',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                                final ImageProvider imageToShow =
                                    (category['img'] != null && category['img'].toString().isNotEmpty)
                                        ? NetworkImage(category['img'].toString().startsWith('http')
                                          ? category['img']
                                          : "https://olivedrab-llama-457480.hostingersite.com/public/${category['img']}")
                                        : AssetImage(category['image'] ?? 'assets/default_category.png');
                                return Card(
                                  color: boxColor,
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            color: Colors.grey[200],
                                            child: Image(
                                              image: imageToShow,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Icon(Icons.image_not_supported, size: 70);
                                              },
                                            ),
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
    );
  }
}