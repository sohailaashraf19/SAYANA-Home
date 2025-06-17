import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/buyer_login_screen.dart';

import '../../data/repositories/buyerreset_repo.dart';
import '../../logic/cubit/buyerpassw_cubit.dart';
import '../../logic/cubit/buyerpass_state.dart';

class BuyerResetPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;

  const BuyerResetPasswordScreen({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BuyerResetPasswordCubit(BuyerresetRepository(Dio())),
      child: _BuyerResetPasswordContent(email: email, otp: otp),
    );
  }
}

/* ───────────────────────── Content ───────────────────────── */

class _BuyerResetPasswordContent extends StatefulWidget {
  final String email;
  final String otp;

  const _BuyerResetPasswordContent({required this.email, required this.otp});

  @override
  State<_BuyerResetPasswordContent> createState() => _BuyerResetPasswordContentState();
}

class _BuyerResetPasswordContentState extends State<_BuyerResetPasswordContent> {
  bool showPwd1 = false, showPwd2 = false;
  final pwd = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() {
    pwd.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003664),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Reset password', style: TextStyle(fontSize: 20.sp, color: Colors.white)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: BlocConsumer<BuyerResetPasswordCubit, BuyerResetPasswordState>(
            listener: (context, state) {
              if (state is BuyerResetPasswordSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BuyerLoginScreen()));
              } else if (state is BuyerResetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Text('Create a new password', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(height: 24.h),
                  _label('New password'),
                  _passwordField(pwd, showPwd1, () => setState(() => showPwd1 = !showPwd1)),
                  SizedBox(height: 20.h),
                  _label('Confirm new password'),
                  _passwordField(confirm, showPwd2, () => setState(() => showPwd2 = !showPwd2)),
                  const Spacer(),
                  _submitButton(context, state),
                  SizedBox(height: 30.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /* ───────────────────────── widgets ───────────────────────── */

  Widget _label(String text) => Text(text, style: TextStyle(fontSize: 18.sp));

  Widget _passwordField(TextEditingController ctrl, bool visible, VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: !visible,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context, BuyerResetPasswordState state) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003664),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
        onPressed: state is BuyerResetPasswordLoading ? null : () {
          final p = pwd.text.trim();
          final c = confirm.text.trim();

          if (p.isEmpty || c.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
          } else if (p != c) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
          } else {
            BuyerResetPasswordCubit.get(context).resetPassword(
              email: widget.email,
              otp: widget.otp,
              password: p,
              confirmPassword: c,
            );
          }
        },
        child: state is BuyerResetPasswordLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text('Done', style: TextStyle(fontSize: 18.sp, color: Colors.white)),
      ),
    );
  }
}
