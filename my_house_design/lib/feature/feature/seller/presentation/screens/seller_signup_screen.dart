import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/seller/data/repositories/seller_auth_repo.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_register_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/seller_register_state.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/seller_login_screen.dart';
import 'package:my_house_design/presentation/widgets/color.dart';

class SellerSignUpScreen extends StatefulWidget {
  const SellerSignUpScreen({super.key});

  @override
  _SellerSignUpScreenState createState() => _SellerSignUpScreenState();
}

class _SellerSignUpScreenState extends State<SellerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptPolicy = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SellerRegisterCubit(SellerAuthRepo()),
      child: BlocConsumer<SellerRegisterCubit, SellerRegisterState>(
        listener: (context, state) {
          if (state is SellerRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SellerLoginScreen()),
            );
          } else if (state is SellerRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
              return Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  backgroundColor: backgroundColor,
                  elevation: 0,
                  centerTitle: true,
                  title: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                buildTextField(
                                  label: 'Brand Name',
                                  controller: _brandNameController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Brand name is required'
                                      : null,
                                ),
                                SizedBox(height: 16.h),
                                buildTextField(
                                  label: 'Phone Number',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => value!.isEmpty
                                      ? 'Phone number is required'
                                      : null,
                                ),
                                SizedBox(height: 16.h),
                                buildTextField(
                                  label: 'Email Address',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!RegExp(r'\S+@\S+\.\S+')
                                        .hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                buildTextField(
                                  label: 'Password',
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() =>
                                          _isPasswordVisible =
                                              !_isPasswordVisible);
                                    },
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'Password is required'
                                      : null,
                                ),
                                SizedBox(height: 16.h),
                                buildTextField(
                                  label: 'Confirm Password',
                                  controller: _confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(_isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() => _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible);
                                    },
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Confirm password is required';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                // Revenue‑sharing agreement
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 12.h, left: 4.w, right: 4.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: _acceptPolicy,
                                        activeColor: primaryColor,
                                        onChanged: (value) {
                                          setState(() {
                                            _acceptPolicy = value ?? false;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black87),
                                            children: [
                                              const TextSpan(
                                                  text:
                                                      'I acknowledge and accept that '),
                                              TextSpan(
                                                text: 'SYANA HOME ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              ),
                                              const TextSpan(text: 'will retain '),
                                              const TextSpan(
                                                text: '5% ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const TextSpan(
                                                text:
                                                    'of my total sales as a platform service fee. This agreement is required to continue registration.',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            state is SellerRegisterLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (!_acceptPolicy) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please accept the revenue‑sharing agreement to proceed.',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      if (_formKey.currentState!.validate()) {
                                        SellerRegisterCubit.get(context)
                                            .registerSeller(
                                          phone: _phoneController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          passwordConfirmation:
                                              _confirmPasswordController.text,
                                          brandName: _brandNameController.text,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.h),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 16.sp),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SellerLoginScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}