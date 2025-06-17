import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/core/core/helper/cache_helper.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/BuyerProfileCubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_profile_state.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/HistoryOrderCubit.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/order_details_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003664),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          },
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BuyerProfileCubit()..fetchProfile()),
          BlocProvider(
            create: (context) {
              final historyOrderCubit = HistoryOrderCubit();
              final buyerId = CacheHelper.getData(key: 'buyerId');
              if (buyerId != null) {
                historyOrderCubit.fetchHistoryOrders();
              }
              return historyOrderCubit;
            },
          ),
        ],
        child: BlocConsumer<BuyerProfileCubit, BuyerProfileState>(
          listener: (context, state) {
            if (state is BuyerProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Profile updated successfully')),
              );
            } else if (state is BuyerProfileUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ ${state.error}')),
              );
            }
          },
          builder: (context, profileState) {
            if (profileState is BuyerProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (profileState is BuyerProfileSuccess) {
              final profile = profileState.profileData;
              nameController.text = profile['name'] ?? '';
              emailController.text = profile['email'] ?? '';
              phoneController.text = profile['phone'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            'assets/images/1000_F_113416666_a7CuS6cvc6D5P5ezUbsTMexJHm9iAgga.jpg',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildInputField(Icons.person, 'Name', nameController),
                      _buildInputField(Icons.email, 'Email', emailController),
                      _buildInputField(Icons.phone, 'Phone', phoneController),
                      SizedBox(height: 20),
                      profileState is BuyerProfileUpdating
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF003664),
                              ),
                              onPressed: () {
                                final cubit = context.read<BuyerProfileCubit>();
                                cubit.updateProfile(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                );
                              },
                              child: Text("Save", style: TextStyle(color: Colors.white)),
                            ),
                      SizedBox(height: 30),
                      Text(
                        'History Orders',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      BlocBuilder<HistoryOrderCubit, HistoryOrderState>(
                        builder: (context, orderState) {
                          if (orderState is HistoryOrderLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (orderState is HistoryOrderSuccess) {
                            if (orderState.orders.isEmpty) {
                              return Text('No past orders found.');
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orderState.orders.length,
                              itemBuilder: (context, index) {
                                final order = orderState.orders[index];
                                final orderItems = order['order_items'] as List<dynamic>? ?? [];
                                final firstItem = orderItems.isNotEmpty ? orderItems[0] : null;

                                final productName = firstItem != null
                                    ? firstItem['product']['name'] ?? 'Unknown'
                                    : 'Unknown';
                                final orderDate = order['order_date'] ?? 'No date';
                                final orderId = order['id'];
                                final buyerId = CacheHelper.getData(key: 'buyerId');

                                return Card(
                                  color: boxColor,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    title: Text('Order #$orderId'),
                                    subtitle: Text('Product: $productName\nDate: $orderDate'),
                                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () {
                                      if (buyerId != null) {
                                        final products = orderItems.map((item) {
                                          return {
                                            'product': item['product'],
                                            'quantity': item['quantity'],
                                          };
                                        }).toList();

                                        final orderData = {
                                          'order_id': order['id'] ?? 'N/A',
                                          'created_at': order['order_date'] ?? 'Unknown',
                                          'status': order['status'] ?? 'Pending',
                                          'total_price': order['total_price'] ?? 0,
                                          'products': products,
                                        };

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OrderDetailsPage(orderData: orderData),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('❌ Buyer ID not found in cache')),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          } else if (orderState is HistoryOrderFailure) {
                            return Text('❌ ${orderState.error}');
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (profileState is BuyerProfileFailure) {
              return Center(child: Text("❌ ${profileState.error}"));
            } else {
              return Center(child: Text(""));
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String label, TextEditingController controller) {
    return Card(
      color: boxColor,
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
