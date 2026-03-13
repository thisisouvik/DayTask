import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final Color? color;

  const BasicAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, 
    style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(height ?? 80), backgroundColor: color),
    child: Text(text, style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)), 
    );
  }
}
