import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../buyer/data/repositories/buyerotp_repo.dart';
import '../../../buyer/logic/cubit/buyer_otpverified_cubit.dart';
import '../../../buyer/logic/cubit/buyer_otpverified_state.dart';
import 'buyer_reset_password_screen.dart';

class BuyerOtpVerificationPage extends StatefulWidget {
  final String email;
  const BuyerOtpVerificationPage({Key? key, required this.email, required String otp}) : super(key: key);

  @override
  State<BuyerOtpVerificationPage> createState() => _BuyerOtpVerificationPageState();
}

/* ───────────────────────── State ───────────────────────── */

class _BuyerOtpVerificationPageState extends State<BuyerOtpVerificationPage> {
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  late Timer _timer;
  int sec = 47;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && sec > 0) setState(() => sec--);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final c in controllers) c.dispose();
    super.dispose();
  }

  /* ───────────────────────── Helpers ───────────────────────── */

  String _otp() => controllers.map((e) => e.text).join();

  Widget _box(TextEditingController ctrl, int i) => Container(
        width: 48,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE1FF), // light blue box
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: ctrl,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22),
          maxLength: 1,
          decoration: const InputDecoration(counterText: '', border: InputBorder.none),
          onChanged: (v) {
            if (v.length == 1 && i < 5) {
              FocusScope.of(context).nextFocus();
            } else if (v.isEmpty && i > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      );

  void _verify(BuildContext ctx) {
    final otp = _otp();
    if (otp.length == 6) {
      BuyerOtpCubit.get(ctx).verifyOtp(email: widget.email, otp: otp);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter 6 digits')));
    }
  }

  /* ───────────────────────── UI ───────────────────────── */

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BuyerOtpCubit(BuyerOtpRepository(Dio())),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF003664),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Forget password', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocConsumer<BuyerOtpCubit, BuyerOtpState>(
            listener: (ctx, state) {
              if (state is BuyerOtpSuccess) {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.pushReplacement(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => BuyerResetPasswordScreen(email: widget.email, otp: _otp()),
                  ),
                );
              } else if (state is BuyerOtpError) {
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (ctx, state) {
              return Column(
                children: [
                  const SizedBox(height: 32),
                  Text('Send code to ${widget.email}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (i) => _box(controllers[i], i)),
                  ),
                  const SizedBox(height: 16),
                  sec > 0
                      ? Text('Resend code in 0:${sec.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 14))
                      : TextButton(
                          onPressed: () {
                            // TODO: call resend endpoint
                            setState(() => sec = 47);
                          },
                          child: const Text('Resend Code', style: TextStyle(color: Color(0xFF003664))),
                        ),
                  const Spacer(),
                  if (state is BuyerOtpLoading)
                    const CircularProgressIndicator()
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _verify(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003664),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text('Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
