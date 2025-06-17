import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/otprepo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_request_otp_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_request_otp_state.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/otpverify_cubit.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/otpverify_screen.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_login_screen.dart';

class ForgtpassScreen extends StatelessWidget {
  const ForgtpassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return BlocProvider(
      create: (_) => SellerRequestOtpCubit(),
      child: BlocConsumer<SellerRequestOtpCubit, SellerRequestOtpState>(
        listener: (context, state) {
          if (state is SellerRequestOtpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => OtpCubit(OtpRepository(DioHelper.dio)),
                  child: OtpVerificationPage(email: emailController.text.trim()),
                ),
              ),
            );
          } else if (state is SellerRequestOtpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FA),
            appBar: AppBar(
              title: Center(
                child: Text("Forget password", style: TextStyle(fontSize: 20.sp, color: Colors.white)), // Changed to white
              ),
              backgroundColor: Color(0xFF003664),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white), // White arrow icon
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SellerLoginScreen()), // Navigate to Login screen
                  );
                },
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    "We will send a verification code\nto you to reset your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30.h),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      prefixIcon: const Icon(Icons.email, color: Color(0xFF003664)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF003664),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                      ),
                      onPressed: () {
                        final email = emailController.text.trim();
                        if (email.isNotEmpty) {
                          SellerRequestOtpCubit.get(context).requestOtp(email);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter your email'), backgroundColor: Colors.orange),
                          );
                        }
                      },
                      child: state is SellerRequestOtpLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Continue", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
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
