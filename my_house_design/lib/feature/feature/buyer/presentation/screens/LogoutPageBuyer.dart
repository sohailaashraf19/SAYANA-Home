import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_logout_cubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_logout_state.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/choose_role_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear session data
    await prefs.remove('token'); // Remove token
    await prefs.remove('buyerName'); // Remove buyer name
    await prefs.remove('buyerId'); // Remove buyer ID
  

    // Print messages to console
    print('✅ Token removed from session.');
    print('✅ Buyer Name removed from session.');
    print('✅ Buyer ID removed from session.');
   
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BuyerLogoutCubit(),
      child: BlocConsumer<BuyerLogoutCubit, BuyerLogoutState>(
        listener: (context, state) async {
          if (state is BuyerLogoutSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            await clearSession(); // Clear session data
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) =>  ChooseRoleScreen()),
              (route) => false, // This ensures the user can't navigate back to the logout page
            );
          } else if (state is BuyerLogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logout failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Color(0xFF003664),
            appBar: AppBar(
              title: const Text('Logout'),
              backgroundColor: Color(0xFF003664),
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white, size: 80),
                  SizedBox(height: 20),
                  Text(
                    "Are you sure you want to logout?",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      final cubit = BuyerLogoutCubit.get(context);
                      cubit.logoutBuyer(); // Trigger the logout action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
