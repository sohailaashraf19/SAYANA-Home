import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_house_design/feature/feature/buyer/presentation/screens/guest.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> _imagePaths = [
    'assets/images/WhatsApp Image 2025-06-16 at 2.42.44 AM.jpeg',
    'assets/images/WhatsApp Image 2025-06-16 at 2.43.49 AM.jpeg',
    'assets/images/pp14.png',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageSequence();
  }

  void _startImageSequence() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < _imagePaths.length - 1) {
        setState(() => _currentIndex++);
      } else {
        _timer?.cancel();
        // بعد انتهاء الصور ما ننتقل تلقائي، خلي المستخدم يضغط السهم فقط
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToGuest() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeView()), // أو Guest() حسب ما تريد
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: Image.asset(
                _imagePaths[_currentIndex],
                key: ValueKey<String>(_imagePaths[_currentIndex]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              bottom: 16.h,
              right: 12.w,
              child: GestureDetector(
                onTap: _goToGuest,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
