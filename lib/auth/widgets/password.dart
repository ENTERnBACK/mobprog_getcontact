import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator; 

  const Password({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.validator,
  });

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool _sembunyi = true; 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _sembunyi,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_sembunyi ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _sembunyi = !_sembunyi),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}