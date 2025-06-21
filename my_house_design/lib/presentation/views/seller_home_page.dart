import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/sarch_bar_home.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/count_remote_data_source.dart';
import 'package:my_house_design/feature/feature/seller/data/models/HighestSpendingCustomerModel.dart';
import 'package:my_house_design/feature/feature/seller/data/models/TopSellingProductModel.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/HighestSpendingCustomerCubit%20.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/TopSellingProductsCubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/product_count_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/product_count_state.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/revenue_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/revenue_state.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_orders_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_orders_state.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/unique_buyers_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/unique_buyers_state.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/Settingss_Page.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/products_screen.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_orders_page.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/botttomnavbar.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  int currentIndex = 2;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = SummaryRemoteDataSource(Dio());

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UniqueBuyersCubit(remoteDataSource)..getUniqueBuyers()),
        BlocProvider(create: (_) => RevenueCubit(remoteDataSource)..getRevenue()),
        BlocProvider(create: (_) => OrdersCountCubit(remoteDataSource)..getOrdersCount()),
        BlocProvider(create: (_) => ProductCountCubit(remoteDataSource)..getProductCount()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SellerTopBar(
                  userName: userName,
                  userImageUrl: 'assets/images/SYANA HOME.png',
                ),
                const SizedBox(height: 16),
                const SearchBarHome(),
                const SizedBox(height: 16),
                const SummaryCardsWidget(),
                const SizedBox(height: 24),
                const TrendingProductsWidget(),
                const SizedBox(height: 24),
                const HighestSpendingCustomersWidget(),
              ],
            ),
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
                  destination = const ProductScreen();
                  break;
                case 1:
                  destination = const SellerOrdersPage();
                  break;
                case 2:
                  destination = const SellerHomePage();
                  break;
                case 3:
                  destination = const SettingssPage();
                  break;
                default:
                  destination = const SellerHomePage();
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => destination),
              );
            }
          },
          items: [
            navitem(icon: Icons.inventory_2_outlined, label: "Products", index: 0, currentIndex: currentIndex),
            navitem(icon: Icons.shopping_cart_outlined, label: "Orders", index: 1, currentIndex: currentIndex),
            navitem(icon: Icons.home, label: "Home", index: 2, currentIndex: currentIndex),
            navitem(icon: Icons.settings, label: "Settings", index: 3, currentIndex: currentIndex),
          ],
          selectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SellerTopBar extends StatelessWidget {
  final String userName;
  final String userImageUrl;

  const SellerTopBar({
    super.key,
    required this.userName,
    required this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(userImageUrl),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thursday, Feb 5, 1985',
                style: TextStyle(fontSize: 12, color: Color(0xFF003664)),
              ),
              Text(
                'Hello $userName !',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003664),
                  fontFamily: 'Cursive',
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none, color: Color(0xFF003664)),
      ],
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  final List<String> suggestions;

  const SearchBarWidget({super.key, required this.suggestions});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredSuggestions = [];

  void _onSearchChanged(String query) {
    setState(() {
      _filteredSuggestions = widget.suggestions
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search order, product, customer',
            hintStyle: const TextStyle(color: Color(0xFF003664)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF003664)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Color(0xFF003664)),
            ),
            filled: true,
            fillColor: boxColor,
          ),
          style: const TextStyle(color: Color(0xFF003664)),
        ),
        const SizedBox(height: 10),
        ..._filteredSuggestions.map((suggestion) => ListTile(
              title: Text(suggestion, style: const TextStyle(color: Color(0xFF003664))),
              onTap: () {
                _controller.text = suggestion;
                setState(() {
                  _filteredSuggestions.clear();
                });
              },
            )),
      ],
    );
  }
}

class SummaryCardsWidget extends StatelessWidget {
  const SummaryCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueCubit, RevenueState>(
      builder: (context, revenueState) {
        if (revenueState is RevenueLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (revenueState is RevenueLoaded) {
          final revenueData = revenueState.data;

          return BlocBuilder<OrdersCountCubit, OrdersCountState>(
            builder: (context, ordersState) {
              final totalOrders = (ordersState is OrdersCountLoaded)
                  ? ordersState.data.totalOrdersParticipatedIn.toString()
                  : '...';

              return BlocBuilder<UniqueBuyersCubit, UniqueBuyersState>(
                builder: (context, buyersState) {
                  final totalCustomers = (buyersState is UniqueBuyersLoaded)
                      ? buyersState.data.uniqueBuyersCount.toString()
                      : '...';

                  return BlocBuilder<ProductCountCubit, ProductCountState>(
                    builder: (context, productState) {
                      if (productState is ProductCountLoaded) {
                        final productCount = productState.data.productCount;

                        // --- MODIFIED BLOCK: decrease aspectRatio & card height, fit text ---
                        return GridView(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.05, // was 1.3
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildCard(
                              title: 'Revenue',
                              value: 'EGP ${revenueData.netProfit95Percent.toStringAsFixed(2)}',
                              icon: Icons.attach_money,
                              bgColor: Colors.green.shade100,
                              iconColor: Colors.green.shade700,
                            ),
                            _buildCard(
                              title: 'Total Sales',
                              value: 'EGP ${revenueData.totalSalesBeforeFees}',
                              icon: Icons.bar_chart,
                              bgColor: Colors.orange.shade100,
                              iconColor: Colors.orange.shade700,
                            ),
                            _buildCard(
                              title: 'Total Orders',
                              value: totalOrders,
                              icon: Icons.shopping_bag,
                              bgColor: Colors.blue.shade100,
                              iconColor: Colors.blue.shade700,
                            ),
                            _buildCard(
                              title: 'Customers',
                              value: totalCustomers,
                              icon: Icons.people,
                              bgColor: Colors.purple.shade100,
                              iconColor: Colors.purple.shade700,
                            ),
                            _buildCard(
                              title: 'Products',
                              value: '$productCount',
                              icon: Icons.inventory,
                              bgColor: Colors.teal.shade100,
                              iconColor: Colors.teal.shade700,
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              );
            },
          );
        } else if (revenueState is RevenueError) {
          return Center(child: Text('Revenue Error: ${revenueState.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      height: 110, // FIXED HEIGHT to avoid overflow
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003664),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class TrendingProductsWidget extends StatelessWidget {
  const TrendingProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopSellingProductCubit()..fetchTopSellingProducts(),
      child: BlocBuilder<TopSellingProductCubit, List<TopSellingProduct>>(
        builder: (context, products) {
          if (products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trending Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003664),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Container(
                      width: 140,
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: product.imageUrl.isNotEmpty
                                  ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/placeholder.png',
                                      image: product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      imageErrorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image, size: 50, color: Color(0xFF003664)),
                                    )
                                  : const Icon(Icons.chair_alt_rounded, size: 50, color: Color(0xFF003664)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003664),
                                  ),
                                ),
                                Text(
                                  '${product.totalSold} Sold',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF003664)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HighestSpendingCustomersWidget extends StatelessWidget {
  const HighestSpendingCustomersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HighestSpendingCustomerCubit()..fetchHighestSpendingCustomers(),
      child: BlocBuilder<HighestSpendingCustomerCubit, List<HighestSpendingCustomer>>(
        builder: (context, customers) {
          if (customers.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Highest Spending Customers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003664)),
              ),
              const SizedBox(height: 12),
              Column(
                children: customers.map((customer) {
                  return ListTile(
                    title: Text(customer.name, style: const TextStyle(color: Color(0xFF003664))),
                    subtitle: Text(
                      "Total Orders: ${customer.totalOrders}",
                      style: const TextStyle(color: Color(0xFF003664)),
                    ),
                    trailing: const Icon(Icons.more_vert, color: Color(0xFF003664)),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}