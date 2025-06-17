import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/reset_repo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/resetoass_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/resetpass_state.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(ResetPasswordRepository(Dio())),
      child: ResetPasswordContent(email: email, otp: otp),
    );
  }
}

class ResetPasswordContent extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordContent({required this.email, required this.otp});

  @override
  _ResetPasswordContentState createState() => _ResetPasswordContentState();
}

class _ResetPasswordContentState extends State<ResetPasswordContent> {
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003664), // Blue background for AppBar
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white), // Arrow icon to go back
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SellerLoginScreen()), // Navigate to login page
            ),
          ),
          title: Center(
            child: Text(
              'Reset password',
              style: TextStyle(fontSize: 20.sp, color: Colors.white), // White text color
            ),
          ),
        ),
        backgroundColor: Colors.white, // White background for the screen
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SellerLoginScreen()),
                );
              } else if (state is ResetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a new password',
                    style: TextStyle(fontSize: 20.sp, color: Colors.black),
                  ),
                  SizedBox(height: 20.h),
                  Text('New password', style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                  SizedBox(height: 15.h),
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible1 ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible1 = !_isPasswordVisible1;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text("Confirm new password", style: TextStyle(fontSize: 20.sp, color: Colors.black)),
                  SizedBox(height: 5.h),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !_isPasswordVisible2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible2 ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible2 = !_isPasswordVisible2;
                          });
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003664), // Blue background for button
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                      ),
                      onPressed: state is ResetPasswordLoading
                          ? null
                          : () {
                              final password = passwordController.text.trim();
                              final confirm = confirmPasswordController.text.trim();

                              if (password.isEmpty || confirm.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please fill all fields")),
                                );
                              } else if (password != confirm) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Passwords do not match")),
                                );
                              } else {
                                ResetPasswordCubit.get(context).resetPassword(
                                  email: widget.email,
                                  otp: widget.otp,
                                  password: password,
                                  confirmPassword: confirm,
                                );
                              }
                            },
                      child: state is ResetPasswordLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Done", style: TextStyle(fontSize: 18.sp, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
