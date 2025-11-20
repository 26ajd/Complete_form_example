import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? icon;

  const CustomTextField({
    this.icon,
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,

        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}
