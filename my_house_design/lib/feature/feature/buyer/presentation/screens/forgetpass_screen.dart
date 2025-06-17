import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/core/core/network/dio_helper.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyerotp_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_otpverified_cubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/otprequest_cubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/otprequest_state.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/buyer_login_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/buyer_otp_verification_page.dart';

class ForgetPassScreen extends StatelessWidget {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return BlocProvider(
      create: (_) => BuyerRequestOtpCubit(),
      child: BlocConsumer<BuyerRequestOtpCubit, BuyerRequestOtpState>(
        listener: (context, state) {
          if (state is BuyerRequestOtpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) => BuyerOtpCubit(BuyerOtpRepository(DioHelper.dio)),
                  child: BuyerOtpVerificationPage(email: emailController.text.trim(), otp: ''),
                ),
              ),
            );
          } else if (state is BuyerRequestOtpError) {
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
                    MaterialPageRoute(builder: (context) => BuyerLoginScreen()), // Navigate to Login screen
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
                          BuyerRequestOtpCubit.get(context).requestOtp(email);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter your email'), backgroundColor: Colors.orange),
                          );
                        }
                      },
                      child: state is BuyerRequestOtpLoading
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
