import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyer_auth_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_register_cubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_register_state.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/buyer_login_screen.dart';
import 'package:my_house_design/presentation/widgets/color.dart';


class BuyerSignUpScreen extends StatefulWidget {
  const BuyerSignUpScreen({super.key});

  @override
  _BuyerSignUpScreenState createState() => _BuyerSignUpScreenState();
}

class _BuyerSignUpScreenState extends State<BuyerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailChecked = false;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyerRegisterCubit(BuyerAuthRepo()),
      child: BlocConsumer<BuyerRegisterCubit, BuyerRegisterState>(
        listener: (context, state) {
          if (state is BuyerRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.registerModel.message)),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BuyerLoginScreen()),
            );
          } else if (state is BuyerRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
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
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone Number is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    suffixIcon: Checkbox(
                                      value: _isEmailChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _isEmailChecked = value ?? false;
                                        });
                                      },
                                      activeColor: primaryColor,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Confirm Password is required';
                                    } else if (value != passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BuyerRegisterCubit.get(context).registerBuyer(
                                  name: nameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  passwordConfirmation: confirmPasswordController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                            ),
                            child: state is BuyerRegisterLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Center(
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
                          SizedBox(height: 16.h),
                          Text(
                            '───────or continue with───────',
                            style: TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Image.asset('assets/images/apple.png', width: 40.w, height: 40.h),
                                onPressed: () {},
                              ),
                              SizedBox(width: 16.w),
                              IconButton(
                                icon: Image.asset('assets/images/google.png', width: 40.w, height: 40.h),
                                onPressed: () {},
                              ),
                              SizedBox(width: 16.w),
                              IconButton(
                                icon: Image.asset('assets/images/facebook.png', width: 40.w, height: 40.h),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(color: Colors.black, fontSize: 16.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BuyerLoginScreen()),
                                  );
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.black,
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
              );
            },
          );
        },
      ),
    );
  }
}
