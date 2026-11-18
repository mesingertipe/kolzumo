import 'package:flutter/material.dart';

class ButtonForm extends StatelessWidget {
  final String textButton;
  final Color colorButton;
  final VoidCallback onPressed;

  const ButtonForm({super.key, required this.textButton, required this.colorButton, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
      backgroundColor: colorButton,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      ),
      child: Text(textButton, style: TextStyle(fontSize: 14, color: Colors.white)),
    );
  }
}