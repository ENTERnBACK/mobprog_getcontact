import 'package:flutter/material.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/input.dart';
import 'widgets/password.dart';
import 'widgets/auth_tabs.dart';

class AuthScreen extends StatefulWidget {
  final bool isLoginAwal;
  
  const AuthScreen({super.key, this.isLoginAwal = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();


  late bool _isLogin = widget.isLoginAwal;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    _confirmController.dispose();
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
              const SizedBox(height: 24),
              AuthTabs(
                isLogin: _isLogin,
                onChanged: (nilai) => setState(() => _isLogin = nilai),
              ),
              const SizedBox(height: 24),
              Input(
                controller: _idController,
                label: 'Email / No. HP',
                hint: 'contoh@email.com atau 08123456789',
                icon: Icons.person_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Password(controller: _passController),
              if (!_isLogin) ...[
                const SizedBox(height: 16),
                Password(
                  controller: _confirmController,
                  label: 'Konfirmasi Password',
                ),
              ],
              const SizedBox(height: 28),
              AuthButton(
                label: _isLogin ? 'Login' : 'Sign Up',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}