import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller; 
  final String label; 
  final String hint; 
  final IconData icon; 
  final TextInputType keyboardType; 
  final String? Function(String?)? validator; 

  const Input({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}