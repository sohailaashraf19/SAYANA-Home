import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/data/data_sources/seller_auth_data_source.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/seller_repologout.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_logout_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_logout_state.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/choose_role_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SellerLogoutPage extends StatelessWidget {
  const SellerLogoutPage({super.key});

  Future<void> clearSellerSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('seller_id');
    await prefs.remove('sellerName');

    print('✅ Seller token removed.');
    print('✅ Seller ID removed.');
    print('✅ Seller name removed.');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SellerLogoutCubit(SellerRepository(SellerAuthRemoteDataSource())),
      child: BlocConsumer<SellerLogoutCubit, SellerLogoutState>(
        listener: (context, state) async {
          if (state is SellerLogoutSuccess) {
            await clearSellerSession();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => ChooseRoleScreen()),
              (route) => false,
            );
          } else if (state is SellerLogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout Failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF003664),
            appBar: AppBar(
              title: const Text('Logout'),
              backgroundColor: const Color(0xFF003664),
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: state is SellerLogoutLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.white, size: 80),
                        const SizedBox(height: 20),
                        const Text(
                          "Are you sure you want to logout?",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            SellerLogoutCubit.get(context).logoutSeller();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Confirm Logout",
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 16, 
                            ),
                          ),

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
