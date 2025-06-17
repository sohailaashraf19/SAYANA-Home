

import 'package:flutter/material.dart';


void navigateTo(BuildContext context,Widget screen) {
  Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => screen ) ,);
}



Widget nextButton(BuildContext context, Widget nextPage) {
  return SizedBox(
    width: 350, //buttton width
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF003664),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => navigateTo(context, nextPage),
      child: Center(
        child: Text(
          "Next",
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
