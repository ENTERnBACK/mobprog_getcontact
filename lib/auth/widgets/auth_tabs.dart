import 'package:flutter/material.dart';

class AuthTabs extends StatelessWidget {
  final bool isLogin; 
  final ValueChanged<bool> onChanged; 

  const AuthTabs({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  Widget _tab(String teks, bool aktif, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: aktif ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            teks,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tab('Login', isLogin, () => onChanged(true)),
          _tab('Sign Up', !isLogin, () => onChanged(false)),
        ],
      ),
    );
  }
}