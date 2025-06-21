import 'package:admin_sayana/Screens/Home/admin_home_page.dart';
import 'package:admin_sayana/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Feedback model
class FeedbackItem {
  final int id;
  final String note;
  final int? sellerId;
  final int? buyerId;
  final String createdAt;
  final String senderType;

  FeedbackItem({
    required this.id,
    required this.note,
    required this.sellerId,
    required this.buyerId,
    required this.createdAt,
    required this.senderType,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'],
      note: json['note'] ?? '',
      sellerId: json['seller_id'],
      buyerId: json['buyer_id'],
      createdAt: json['created_at'],
      senderType: json['sender_type'] ?? '',
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<FeedbackItem> feedbackList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    try {
      final response = await http.get(
        Uri.parse("https://olivedrab-llama-457480.hostingersite.com/public/api/getAllFeedbacks"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          feedbackList = data.map((item) => FeedbackItem.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "حدث خطأ أثناء تحميل الفيدباك!";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "حدث خطأ أثناء الاتصال بالخادم!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Feedbacks"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: primaryColor),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage(onItemSelected: (_) {})),
              (route) => false,
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : feedbackList.isEmpty
                  ? const Center(child: Text("No Feedback Yet"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: feedbackList.length,
                      itemBuilder: (context, index) {
                        final feedback = feedbackList[index];
                        // Determine id to show
                        String userIdText = '';
                        if (feedback.senderType == 'seller' && feedback.sellerId != null) {
                          userIdText = 'Seller ID: ${feedback.sellerId}';
                        } else if (feedback.senderType == 'buyer' && feedback.buyerId != null) {
                          userIdText = 'Buyer ID: ${feedback.buyerId}';
                        }
                        return Card(
                          color: boxColor,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(
                              feedback.senderType == "buyer"
                                  ? Icons.person
                                  : Icons.storefront,
                              color: feedback.senderType == "buyer"
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                            title: Text(feedback.note),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "From: ${feedback.senderType == "buyer" ? "Buyer" : "Seller"}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (userIdText.isNotEmpty)
                                  Text(
                                    userIdText,
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                Text(
                                  "Date: ${feedback.createdAt.split('T').first}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}