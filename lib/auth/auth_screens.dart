import 'package:flutter/material.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/input.dart';
import 'widgets/password.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const AuthHeader(
                title: 'GetContact',
                subtitle: 'Temukan dan kelola kontakmu dengan mudah',
              ),
              const SizedBox(height: 32),
              Input(
                controller: _idController,
                label: 'Email / No. HP',
                hint: 'contoh@email.com atau 08123456789',
                icon: Icons.person_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Password(controller: _passController),
              const SizedBox(height: 28),
              AuthButton(
                label: 'Lanjut',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}