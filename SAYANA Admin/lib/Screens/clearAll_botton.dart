import 'package:flutter/material.dart';

class ClearallBotton extends StatelessWidget {
  const ClearallBotton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Color(0xffEAE9E5),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Text(
        "clear All",
        style: TextStyle(color: Color(0xff817C76), fontWeight: FontWeight.bold),
      ),
    );
  }
}
