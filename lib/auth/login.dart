import 'package:flutter/material.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_header.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              const AuthHeader(
                title: 'GetContact',
                subtitle: 'Temukan dan kelola kontakmu dengan mudah',
              ),

              const Spacer(flex: 2),

              const Text(
                'Masuk / Daftar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              AuthButton(
                label: 'Login',
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              AuthButton(
                label: 'Sign Up',
                isPrimary: false,
                onPressed: () {},
              ),
              
              const SizedBox(height: 24),

            ],
          ),
        ),
      ),
    );
  }
}