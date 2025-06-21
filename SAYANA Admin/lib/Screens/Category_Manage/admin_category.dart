import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:admin_sayana/theme/color.dart';
import 'package:admin_sayana/Screens/Home/admin_home_page.dart';

class AdminCategoryManage extends StatelessWidget {
  const AdminCategoryManage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminCategory(),
    );
  }
}

class AdminCategory extends StatefulWidget {
  const AdminCategory({super.key});

  @override
  State<AdminCategory> createState() => _AdminCategoryState();
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

  /* ------------------------ FETCH ALL CATEGORIES ------------------------ */
  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final res = await http.get(Uri.parse(
              'https://olivedrab-llama-457480.hostingersite.com/public/api/getAllCategories'))
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        categories = data
            .cast<Map<String, dynamic>>()
            .map((c) => {
                  'Category_id': c['Category_id'],
                  'Name': c['Name'] ?? 'Unknown',
                  'img': c['img'] ?? '',
                })
            .toList();
        setState(() => isLoading = false);
      } else {
        throw Exception('Status ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching categories: $e';
      });
    }
  }

  /* --------------------------- ADD CATEGORY --------------------------- */
  Future<void> addCategoryWithImage(String name, File? img) async {
    final uri = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/storeCategory');
    final req = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..fields['Name'] = name;
    if (img != null) {
      req.files.add(await http.MultipartFile.fromPath('img', img.path));
    }
    try {
      final res = await req.send();
      final body = await res.stream.bytesToString();
      if (res.statusCode == 200 || res.statusCode == 201) {
        _snack('Category "$name" added', false);
        fetchCategories();
      } else {
        _snack('Add failed (${res.statusCode}): $body', true);
      }
    } catch (e) {
      _snack('Error adding: $e', true);
    }
  }

  /* -------------------------- DELETE CATEGORY -------------------------- */
  Future<void> deleteCategory(int id, String name) async {
    try {
      final res = await http.delete(Uri.parse(
          'https://olivedrab-llama-457480.hostingersite.com/public/api/deleteCategory/$id'));
      if (res.statusCode == 200) {
        _snack('Category "$name" deleted', false);
        categories.removeWhere((c) => c['Category_id'] == id);
        setState(() {});
      } else {
        _snack('Delete failed (${res.statusCode})', true);
      }
    } catch (e) {
      _snack('Error deleting: $e', true);
    }
  }

  /* -------------------------- UPDATE CATEGORY -------------------------- */
  Future<void> updateCategory(int id, String newName, File? newImg) async {
    final uri = Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/updateCategory/$id');

    final req = http.MultipartRequest('post', uri)
      ..headers['Accept'] = 'application/json'
      ..fields['Name'] = newName;
    if (newImg != null) {
      req.files.add(await http.MultipartFile.fromPath('img', newImg.path));
    }
    try {
      final res = await req.send();
      final body = await res.stream.bytesToString();
      if (res.statusCode == 200) {
        _snack('Category updated', false);
        final idx = categories.indexWhere((c) => c['Category_id'] == id);
        if (idx != -1) {
          categories[idx]['Name'] = newName;
          if (newImg != null) {
            // refresh image by refetching list or updating url; simplest: refetch
            fetchCategories();
          } else {
            setState(() {});
          }
        }
      } else {
        _snack('Update failed (${res.statusCode}): $body', true);
      }
    } catch (e) {
      _snack('Error updating: $e', true);
    }
  }

  /* ----------------------------- UI & SNACK ---------------------------- */
  void _snack(String msg, bool err) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg), backgroundColor: err ? Colors.red : Colors.green));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomePage(onItemSelected: (_) {})),
              (_) => false),
        ),
        title: const Text('Manage Category',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(
              icon: const Icon(Icons.add, color: primaryColor),
              tooltip: 'Add Category',
              onPressed: showAddDialog),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
                : categories.isEmpty
                    ? const Center(child: Text('No categories found'))
                    : ListView.builder(
                        itemCount: categories.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (ctx, i) {
                          final cat = categories[i];
                          final img = cat['img'] as String;
                          final provider = img.isNotEmpty
                              ? NetworkImage(img.startsWith('http')
                                  ? img
                                  : 'https://olivedrab-llama-457480.hostingersite.com/$img')
                              : const AssetImage('assets/default_category.png') as ImageProvider;

                          return Card(
                            color: boxColor,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image(
                                  image: provider,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                ),
                              ),
                              title: Text(cat['Name']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.grey),
                                    onPressed: () => showUpdateDialog(
                                        cat['Category_id'], cat['Name'], cat['img']),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteCategory(
                                        cat['Category_id'], cat['Name']),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  /* --------------------------- ADD DIALOG --------------------------- */
  void showAddDialog() {
    final nameCtrl = TextEditingController();
    File? picked;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setStateSB) {
        return AlertDialog(
          backgroundColor: boxColor,
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 10),
              if (picked != null)
                Image.file(picked!, width: 80, height: 80, fit: BoxFit.cover),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
                onPressed: () async {
                  final res = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (res != null && res.files.single.path != null) {
                    setStateSB(() => picked = File(res.files.single.path!));
                  }
                },
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(ctx);
                  addCategoryWithImage(name, picked);
                } else {
                  _snack('Name cannot be empty', true);
                }
              },
              child: const Text('Add', style: TextStyle(color: primaryColor)),
            )
          ],
        );
      }),
    );
  }

  /* -------------------------- UPDATE DIALOG -------------------------- */
  void showUpdateDialog(int id, String currentName, String currentImgUrl) {
    final ctrl = TextEditingController(text: currentName);
    File? picked;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (ctx, setStateSB) {
        return AlertDialog(
          backgroundColor: boxColor,
          title: const Text('Update Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              const SizedBox(height: 10),
              picked != null
                  ? Image.file(picked!, width: 80, height: 80, fit: BoxFit.cover)
                  : currentImgUrl.isNotEmpty
                      ? Image.network(
                          currentImgUrl.startsWith('http')
                              ? currentImgUrl
                              : 'https://olivedrab-llama-457480.hostingersite.com/$currentImgUrl',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover)
                      : const SizedBox.shrink(),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick New Image'),
                onPressed: () async {
                  final res = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (res != null && res.files.single.path != null) {
                    setStateSB(() => picked = File(res.files.single.path!));
                  }
                },
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final newName = ctrl.text.trim();
                if (newName.isNotEmpty) {
                  Navigator.pop(ctx);
                  updateCategory(id, newName, picked);
                } else {
                  _snack('Name cannot be empty', true);
                }
              },
              child: const Text('Update', style: TextStyle(color: primaryColor)),
            )
          ],
        );
      }),
    );
  }
}