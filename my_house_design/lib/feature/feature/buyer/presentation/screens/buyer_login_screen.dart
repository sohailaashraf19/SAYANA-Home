import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/buyer/data/repositories/buyer_auth_repo.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_login_cubit.dart';
import 'package:my_house_design/feature/feature/buyer/logic/cubit/buyer_login_state.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/buyer_signup_screen.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/forgetpass_screen.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/choose_role_screen.dart';
import 'package:my_house_design/presentation/widgets/color.dart';

class BuyerLoginScreen extends StatefulWidget {
  const BuyerLoginScreen({super.key});

  @override
  State<BuyerLoginScreen> createState() => _BuyerLoginScreenState();
}

class _BuyerLoginScreenState extends State<BuyerLoginScreen> {
  bool _isRememberMe = false;
  bool _isObscure = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late BuyerLoginCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BuyerLoginCubit(BuyerAuthRepo());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider<BuyerLoginCubit>.value(
      value: cubit,
      child: BlocConsumer<BuyerLoginCubit, BuyerLoginState>(
        listener: (context, state) {
          if (state is BuyerLoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.model.message)),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          } else if (state is BuyerLoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Login',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ChooseRoleScreen()),
                ),
              ),
            ),
            backgroundColor: backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Logo
                    SizedBox(
                      width: screenHeight * 0.4,
                      height: screenHeight * 0.25,
                      child: Image.asset('assets/images/SYANA HOME.png'),
                    ),
                    SizedBox(height: 20.h),
                    // Email
                    _buildTextField(
                      controller: emailController,
                      hintText: 'Email',
                      icon: Icons.email,
                    ),
                    SizedBox(height: 15.h),
                    // Password
                    _buildPasswordField(),
                    _buildOptionsRow(context),
                    SizedBox(height: 10.h),
                    // Sign‑In button
                    if (state is BuyerLoginLoading)
                      const CircularProgressIndicator()
                    else
                      _buildSignInButton(),
                    SizedBox(height: 40.h),
                    // Sign‑Up prompt
                    _buildSignUpRow(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Padding(
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
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              prefixIcon: Icon(icon, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
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
              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isRememberMe,
                activeColor: primaryColor,
                onChanged: (v) => setState(() => _isRememberMe = v ?? false),
              ),
              Text('Remember me', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgetPassScreen()),
            ),
            child: Text(
              'Forget Password?',
              style: TextStyle(
                fontSize: 14.sp,
                decoration: TextDecoration.underline,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: 250.w,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        onPressed: () => cubit.loginBuyer(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        child: Text('Sign In',
            style: TextStyle(fontSize: 18.sp, color: Colors.white)),
      ),
    );
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don’t have an account?',
            style: TextStyle(fontSize: 14.sp, color: Colors.black)),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BuyerSignUpScreen()),
          ),
          child: Text('Sign Up',
              style: TextStyle(fontSize: 16.sp, color: Colors.black)),
        ),
      ],
    );
  }
}