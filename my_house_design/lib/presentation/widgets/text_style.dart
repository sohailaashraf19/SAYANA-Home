
import 'package:flutter/material.dart';
import 'color.dart';  

TextStyle titleTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: boldtextColor, 
);

TextStyle boldTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: boldtextColor, 
);

TextStyle normal14TextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: smalltextColor,  
);
TextStyle normal16TextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: smalltextColor,  
);

TextStyle bold14TextStyle = TextStyle(
   fontSize: 14,
  fontWeight: FontWeight.bold,
  color: smalltextColor,  
);
const headingshadowTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(
      color: Colors.black26,
      offset: Offset(2, 1),
      blurRadius: 2,
    ),
  ],
);


//style: TextStyle(color: boldtextColor, fontSize: 22, fontWeight: FontWeight.bold)
//style: TextStyle(color: boldtextColor , fontSize: 22, fontWeight: FontWeight.bold)