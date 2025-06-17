import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/seller_auth_repo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_login_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_login_state.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/ForgtpassScreen.dart' show ForgtpassScreen;
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_signup_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/choose_role_screen.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:my_house_design/presentation/views/seller_home_page.dart';





class SellerLoginScreen extends StatefulWidget {
  const SellerLoginScreen({super.key});

  @override
  State<SellerLoginScreen> createState() => _SellerLoginScreenState();
}

class _SellerLoginScreenState extends State<SellerLoginScreen> {
  bool _isRememberMe = false;
  bool _isObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => SellerLoginCubit(SellerAuthRepo()),
      child: BlocConsumer<SellerLoginCubit, SellerLoginState>(
        listener: (context, state) {
         if (state is SellerLoginSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(state.seller.message)),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const SellerHomePage(),
    ),
  );
}
 else if (state is SellerLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final cubit = SellerLoginCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Login',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: backgroundColor,
                            leading: IconButton(
  icon: Icon(
    Icons.arrow_back,
    color: const Color.fromARGB(255, 0, 0, 0), // Set the color of the back arrow to white
  ),
  onPressed: () =>  Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChooseRoleScreen(), // أو BuyerHomeScreen لو حابب
              ),
            )
),
            ),
            backgroundColor:backgroundColor, //const Color.fromARGB(255, 255, 255, 255),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: screenHeight * 0.4,
                      height: screenHeight * 0.25,
                      child: Image.asset(
                        'assets/images/SYANA HOME.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextField(
                            controller: passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock,
                                  color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isRememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _isRememberMe = value!;
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgtpassScreen()),
                              );
                            },
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 250.w,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        onPressed: () {
                          cubit.loginSeller(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                        },
                        child: state is SellerLoginLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(thickness: 1, color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(thickness: 1, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/apple.png', height: 40.h),
                        SizedBox(width: 20.w),
                        Image.asset('assets/images/facebook.png', height: 40.h),
                        SizedBox(width: 20.w),
                        Image.asset('assets/images/google.png', height: 40.h),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SellerSignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
