import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/SettingsPage.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/all_categories_page.dart';
import 'dart:convert';

import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/widgets/home_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/wishlistpage.dart';

class ProductDetailPage extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final String imageUrl;
  final int? productId;

  const ProductDetailPage({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.productId,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  TextEditingController _commentController = TextEditingController();
  List<dynamic> comments = [];
  int currentIndex = 0;
  Map<int, bool> favorites = {};
  Map<int, bool> cartItems = {};
  

  @override
  void initState() {
    super.initState();
    fetchWishlist();
      fetchCart(); 
      _fetchComments(); // <-- Just call it normally here

  }

  Future<void> fetchWishlist() async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');

    if (buyerId == null) {
      print('Buyer ID not found');
      return;
    }

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getwishlist?buyer_id=$buyerId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          setState(() {
            for (var item in data) {
              final productId = item['product_id'];
              if (productId != null) {
                favorites[int.parse(productId.toString())] = true;
              }
            }
          });
        }
      } else {
        print('❌ Failed to fetch wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching wishlist: $e');
    }
  }


  // Fetch comments for the product
  Future<void> _fetchComments() async {
    if (widget.productId == null) return;

    final response = await http.get(
      Uri.parse(
        'https://olivedrab-llama-457480.hostingersite.com/public/api/commet_product/${widget.productId}',
      ),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData is Map && responseData.containsKey('data')) {
        setState(() {
          comments = responseData['data'];
        });
      } else {
        setState(() {
          comments = responseData;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments.')),
      );
    }
  }

  // Post a comment
  Future<void> _postComment() async {
    var buyerId = CacheHelper.getData(key: 'buyerId');
    if (buyerId == null || widget.productId == null || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/creatcomments'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'buyer_id': buyerId,
        'product_id': widget.productId,
        'comment': _commentController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment posted successfully!')),
      );
      _commentController.clear();
      _fetchComments();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment.')),
      );
    }
  }

  

  // Add/remove product to/from the wishlist
  Future<void> addToWishlist(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/addwishlist?buyer_id=$buyerId&product_id=${widget.productId}');

    try {
      await http.post(url);
    } catch (e) {
      print('❌ Error adding to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/removewishlist/${widget.productId}?buyer_id=$buyerId');

    try {
      await http.delete(url);
    } catch (e) {
      print('❌ Error removing from wishlist: $e');
    }
  }

  // Cart
  Future<void> fetchCart() async {
  final buyerId = await CacheHelper.getData(key: 'buyerId');
  if (buyerId == null) {
    print('Buyer ID not found');
    return;
  }

  final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/getcart?buyer_id=$buyerId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        setState(() {
          for (var item in data) {
            final productId = item['product_id'];
            if (productId != null) {
              cartItems[int.parse(productId.toString())] = true;
            }
          }
        });
      }
    } else {
      print('❌ Failed to fetch cart: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching cart: $e');
  }
}

  Future<void> addToCart(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/cart_add?product_id=${widget.productId}&buyer_id=$buyerId');

    try {
      await http.post(url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error adding to cart')));
    }
  }

  Future<void> removeFromCart(int productId) async {
    final buyerId = await CacheHelper.getData(key: 'buyerId');
    if (buyerId == null) return;

    final url = Uri.parse('https://olivedrab-llama-457480.hostingersite.com/public/api/cartdelet/${widget.productId}?buyer_id=$buyerId');

    try {
      await http.delete(url);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error removing from cart')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003664),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title,
            style: const TextStyle(color: Colors.white)),
        actions: [
     IconButton(
                                        icon: Icon(
                                          favorites[widget.productId] == true ? Icons.favorite : Icons.favorite_border,
                                          color: favorites[widget.productId] == true ? Colors.red : Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () async {
  if (widget.productId != null) {
    if (favorites[widget.productId] == true) {
      await removeFromWishlist(widget.productId!);
      setState(() {
        favorites[widget.productId!] = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from wishlist')),
      );
    } else {
      await addToWishlist(widget.productId!);
      setState(() {
        favorites[widget.productId!] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to wishlist')),
      );
    }
  }
},
                                      ),

                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          cartItems[widget.productId] == true
                                              ? Icons.shopping_cart
                                              : Icons.shopping_cart_outlined,
                                          color: cartItems[widget.productId] == true ? Colors.green : Colors.white,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          if (widget.productId != null) {
                                            if (cartItems[widget.productId] == true) {
                                              await removeFromCart(widget.productId!);
                                              setState(() {
                                                cartItems[widget.productId!] = false;
                                              });
                                            } else {
                                              await addToCart(widget.productId!);
                                              setState(() {
                                                cartItems[widget.productId!] = true;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
          ],
      ),
      
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.imageUrl),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "\EGP${widget.price}",
              style: const TextStyle(fontSize: 20, color:Color.fromARGB(255, 20, 85, 197),fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.description),
            const SizedBox(height: 8),
            Text(
              widget.productId != null ? "Product ID: ${widget.productId}" : "Product ID: N/A",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Add a Comment',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _postComment,
              style: ElevatedButton.styleFrom(
                backgroundColor: boxColor, 
                foregroundColor: primaryColor,
              ),
              child: Text('Submit Comment'),
            ),
            const SizedBox(height: 16),
            Text(
              'Comments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...comments.map((comment) {
              final buyerName = comment['buyer_name'] ?? 'Unknown';
              final commentText = comment['comment'] ?? '';
              return ListTile(
                title: Text(commentText),
                subtitle: Text('by $buyerName'),
              );
            }).toList(),
          ],
        ),
      ),
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            setState(() {
              currentIndex = index;
            });

            Widget destination;
            switch (index) {
              case 0:
                destination = const AllCategoriesPage();
                break;
              case 1:
                destination = const WishlistPage();
                break;
              case 2:
                destination = const HomeView();
                break;
              case 3:
                destination = const HomeScreen();
                break;
              case 4:
                destination = const SettingsPage();
                break;
              default:
                destination = const HomeView();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        items: [
          navitem(icon: Icons.grid_view, label: "Category", index: 0, currentIndex: currentIndex),
          navitem(icon: Icons.favorite_border, label: "Wishlist", index: 1, currentIndex: currentIndex),
          navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
          navitem(icon: Icons.chat, label: "Chat Bot", index: 3, currentIndex: currentIndex),
          navitem(icon: Icons.settings, label: "Settings", index: 4, currentIndex: currentIndex),
        ],
      ),
    );
  }
}
