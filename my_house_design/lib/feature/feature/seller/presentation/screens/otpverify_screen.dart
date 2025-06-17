import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/ForgtpassScreen.dart';
import 'package:my_house_design/feature/feature/seller/presentation/screens/resetpass_screen%20(1).dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/otpverify_cubit.dart';
import 'package:my_house_design/feature/feature/seller/logic/cubit/otpverify_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  int secondsRemaining = 47;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String getOtp() {
    return controllers.map((c) => c.text).join();
  }

  Widget buildOtpBox(TextEditingController controller) {
    return Container(
      width: 48,
      height: 60,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 221, 221, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  void verifyCode() {
    final otp = getOtp();
    if (otp.length == 6) {
      OtpCubit.get(context).verifyOtp(email: widget.email, otp: otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter 6 digits")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Center(
          child: Text("Forget password", style: TextStyle(fontSize: 20, color: Colors.white)), // White title text
        ),
        backgroundColor: Color(0xFF003664), // Blue background
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ForgtpassScreen()), // Navigate to Login screen
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ResetPasswordScreen(
                    email: widget.email,
                    otp: getOtp(),
                  ),
                ),
              );
            } else if (state is OtpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 32),
                Text('Send code to ${widget.email}', style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controllers.map(buildOtpBox).toList(),
                ),
                SizedBox(height: 16),
                Text(
                  'Resend code ${secondsRemaining > 0 ? "0:${secondsRemaining.toString().padLeft(2, '0')}" : "available"}',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Spacer(),
                if (state is OtpLoading)
                  CircularProgressIndicator()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF003664), // Blue background for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text('Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
