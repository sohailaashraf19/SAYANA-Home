import 'package:flutter/material.dart';
import 'package:my_house_design/presentation/widgets/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatScreen(),
    );
  }
}
