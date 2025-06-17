import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/buyer_login_screen.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_login_screen.dart';
import 'package:my_house_design/presentation/widgets/color.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add the logo image here
              Image.asset(
                'assets/images/SYANA HOME.png', // Path to your logo image
                height: 100.h, // Adjust height to your preference
              ),
              SizedBox(height: 40.h), // Adjust space after the logo
              Text(
                "Choose your account type",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BuyerLoginScreen()),
                  );
                },
                child: Text("I'm a buyer", style: TextStyle(color: Colors.white ,fontSize: 18.sp,)),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SellerLoginScreen()),
                  );
                },
                child: Text("I'm a seller", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
