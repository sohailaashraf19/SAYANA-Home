import 'package:flutter/material.dart';
import '../../../../../presentation/widgets/color.dart';
  

// مخصص للايكونز اللي بيظهر فيها بادجز زي ال cart , notification 
class CustomIconButton extends StatelessWidget {
  final IconData icon;  
  final VoidCallback onPressed;  
  final Color? iconColor;  
  final double? size;  
  final bool hasBadge; 


  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.size,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: iconColor ?? Colors.black,  
            size: size ?? 24.0,  
          ),
          onPressed: onPressed,
        ),
        if (hasBadge) ...[
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: redColor,
              child: Text(
                "3", 
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
